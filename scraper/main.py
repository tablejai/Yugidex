from time import sleep
from path import Path
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
import re
import json
import os

DELAY_TIME = 10
DELAY_TIME_MS = DELAY_TIME * 1000
BASE_DATA_DIRECTORY = "data"
YUGIOH_DIRECTORY = "yugioh"


# driver = webdriver.Firefox()
driver = webdriver.Edge("./driver/msedgedriver.exe")

def writeDataToFile(path: str, data: str, fileName: str):
    if not os.path.exists(path):
            os.makedirs(path)
    file = open(os.path.join(path, fileName), 'w')
    file.write(data)
    file.close()

def loadFileToData(path: str):
    if os.path.exists(path):
        file = open(path, 'r')
        # Read the contents of the file
        file_contents = file.read()
        # Close the file
        file.close()
        return json.loads(file_contents)
    return {}


def getCardListByAlphabet(driver, url):
    #shitty assumptions
    driver.get(url)
    wait = WebDriverWait(driver, DELAY_TIME)
    characterGroup = wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, "category-page__members-wrapper" )))
    for cardGroup in characterGroup:
        urltargets = cardGroup.find_elements(By.CLASS_NAME, "category-page__member-link")
        index = cardGroup.find_element(By.CLASS_NAME, "category-page__first-char").text or len(urltargets)
        pathTarget = os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "base_url")
        fileTarget = os.path.join(pathTarget, "%s.txt" % ( index if index != '"' else "special_char"))
        cardDataList = loadFileToData(fileTarget)
        for card in urltargets:
            name = card.get_attribute('title')
            url = card.get_attribute('href')
            cardDataList[name] = url
        #save shit
        if not os.path.exists(pathTarget):
            os.makedirs(pathTarget)
        writeDataToFile(pathTarget, json.dumps(cardDataList, sort_keys=True, indent=2),"%s.txt" % ( index if index != '"' else "special_char"))

def getCardData(driver, url):
    driver.get(url)

baseCardUrl = "https://yugioh.fandom.com/wiki/Zoroa,_the_Magistus_of_Flame"
rushBaseCardUrl = "https://yugioh.fandom.com/wiki/Super_Magical_Shining_Beast_Magnum_Overlord_(L)"

def getCardData(driver, url:str):
    driver.get(url)
    wait = WebDriverWait(driver, DELAY_TIME)
    cardElements = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "cardtable" )))
    cardData = {}
    pathTarget = os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "card")
    for row in cardElements.find_elements(By.CLASS_NAME, "cardtablerow"):
        #check if its a simple row or table data
        #tableData = row.find_element(By.CLASS_NAME, "cardtablespanrow")
        result = getRowData(row)
        if(len(result) > 1):
            cardData[result[0].lower()] = result[1]
        # else:
        #     result = getTableData(row)
        #     if(result != None and len(result) > 1):
        #         cardData[result[0].lower()] = result[1]

    return cardData
    #writeDataToFile(pathTarget, json.dumps(cardData, indent=2), f'{cardData["english"]}.txt')


def getRowData(element):
    try:
        header = element.find_element(By.CLASS_NAME, "cardtablerowheader").text
        data = element.find_element(By.CLASS_NAME, "cardtablerowdata").text
        return [header, data]
    except Exception:
        print("not row based - wiki")
        return []
    
def getTableData(element):
    try:
        tableRows = element.find_elements(By.CLASS_NAME, "cardtablespanrow")
        data = [element.find_element(By.TAG_NAME, "b").text]
        for section in tableRows:
            rows = section.find_elements(By.CLASS_NAME, "navbox")
            for i in range(len(rows)):
                data.append(getCardDescription(rows[i], i))
        return data
    except Exception as e:  
        print(e)
        return [] #its possible to create a record, maybe future update

def getCardDescription(element, index):
    #assumption hitting the row
    #TODO xpath this garbage //*[@id="collapsibleTable0"]/tbody/tr[1]/th/div
    try:
        #clicking the button to reveal the text
        
        titleBorder = element.find_element(By.CLASS_NAME, "navbox-title")
        clickReveal = titleBorder.find_element(By.XPATH, f'//*[@id="collapseButton{index}"]')
        if(clickReveal.text.lower() == "show"):
            ActionChains(driver).scroll_to_element(clickReveal).perform()
            clickReveal.click() 
        title = titleBorder.find_element(By.TAG_NAME, "div").text
        description = element.find_element(By.CLASS_NAME, "navbox-list")
        return [title, description.text]
    except Exception as e:
        print(e)
        return []


cache = { "curr_url" : "" , "finished" : ""}
pathTarget = os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "base_url")
writeTarget = os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "card")
files = os.listdir(pathTarget)

try:
    for file in files:
        if( file.split(".")[0] in cache["finished"]):
            print(f'skipping {file}')
            continue
        loadedCardByAlphabetical = loadFileToData(os.path.join(pathTarget, file))
        start = False if cache["curr_url"] != "" else True
        for cardName, cardUrl in loadedCardByAlphabetical.items():
            if cache["curr_url"] == cardUrl:
                print("found the start url")
                start = True
            if start == False:
                continue
            cache["curr_url"] = cardUrl
            data = getCardData(driver, cardUrl)
            writeDataToFile(writeTarget, json.dumps(data, indent=2), re.sub(r"[\\\/\:\*\?\"\<\>|]", "-", f'{data["english"]}.txt'))
            sleep(1)
            print(cache)
        cache["finished"] = cache["finished"] + file.split(".")[0]
        cache["curr_url"] = ""
except Exception as e:
    print(e)
    writeDataToFile(os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "cache"),
                    json.dumps(cache),
                    "cache.txt"
                    )

#getCardData(driver, baseCardUrl)

if __name__ == "__main__":
    print("yey")
    # alphabeticalList = "abcdefghijklmnopqrstuvwxyz¡"
    # base_url = "https://yugioh.fandom.com/wiki/Category:OCG_cards"
    # current_url = base_url
    # while True:
    #     getCardListByAlphabet(driver, current_url)
    #     try:
    #         button = driver.find_element(By.CLASS_NAME, "category-page__pagination-next")
    #         current_url = button.get_attribute("href")
    #     except Exception as e:
    #         print("it break")
    #         print(e)
    #         break
