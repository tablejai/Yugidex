# from time import sleep
# from path import Path
# from selenium.webdriver.firefox.options import Options
# from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium.webdriver.edge.options import Options
from time import sleep
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

# utils


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


def scrollToElement(driver: any, element: any):
    driver.execute_script("arguments[0].scrollIntoView(true);", element)

# one time parser


def getCardListByAlphabet(driver, url):
    # shitty assumptions
    driver.get(url)
    wait = WebDriverWait(driver, DELAY_TIME)
    characterGroup = wait.until(EC.presence_of_all_elements_located(
        (By.CLASS_NAME, "category-page__members-wrapper")))
    for cardGroup in characterGroup:
        urltargets = cardGroup.find_elements(
            By.CLASS_NAME, "category-page__member-link")
        index = cardGroup.find_element(
            By.CLASS_NAME, "category-page__first-char").text or len(urltargets)
        pathTarget = os.path.join(
            os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "base_url")
        fileTarget = os.path.join(pathTarget, "%s.txt" % (
            index if index != '"' else "special_char"))
        cardDataList = loadFileToData(fileTarget)
        for card in urltargets:
            name = card.get_attribute('title')
            url = card.get_attribute('href')
            cardDataList[name] = url
        # save shit
        if not os.path.exists(pathTarget):
            os.makedirs(pathTarget)
        writeDataToFile(pathTarget, json.dumps(cardDataList, sort_keys=True,
                        indent=2), "%s.txt" % (index if index != '"' else "special_char"))


# yugioh parser
baseCardUrl = "https://yugioh.fandom.com/wiki/Zoroa,_the_Magistus_of_Flame"
rushBaseCardUrl = "https://yugioh.fandom.com/wiki/Super_Magical_Shining_Beast_Magnum_Overlord_(L)"


def getCardData(driver, url: str):
    driver.get(url)
    wait = WebDriverWait(driver, DELAY_TIME)
    cardElements = wait.until(
        EC.presence_of_element_located((By.CLASS_NAME, "cardtable")))
    cardData = {}
    pathTarget = os.path.join(
        os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "card")
    for row in cardElements.find_elements(By.CLASS_NAME, "cardtablerow"):
        # check if its a simple row or table data
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
        return []  # its possible to create a record, maybe future update


def getCardDescription(element, index):
    # assumption hitting the row
    # TODO xpath this garbage //*[@id="collapsibleTable0"]/tbody/tr[1]/th/div
    try:
        # clicking the button to reveal the text
        titleBorder = element.find_element(By.CLASS_NAME, "navbox-title")
        clickReveal = titleBorder.find_element(
            By.XPATH, f'//*[@id="collapseButton{index}"]')
        if(clickReveal.text.lower() == "show"):
            ActionChains(driver).scroll_to_element(clickReveal).perform()
            clickReveal.click()
        title = titleBorder.find_element(By.TAG_NAME, "div").text
        description = element.find_element(By.CLASS_NAME, "navbox-list")
        return [title, description.text]
    except Exception as e:
        print(e)
        return []


def getCardListByBooster(driver, url: str):
    driver.get(url)
    wait = WebDriverWait(driver, DELAY_TIME)
    tabs = wait.until(EC.presence_of_element_located(
        (By.CLASS_NAME, "tabbernav")))

    scrollToElement(driver, tabs)
    # proto clicking shit
    for tab in tabs.find_elements(By.TAG_NAME, "li"):
        if tab.text.lower() == "japanese":
            tab.click()

    boosterCardTabs = wait.until(EC.presence_of_element_located(
        (By.CLASS_NAME, "set-lists-tabber")))
    boosterData = {
        "url": url
    }
    for tab in boosterCardTabs.find_elements(By.CLASS_NAME, "tabbertab"):
        lang = tab.get_attribute("title").lower()
        if lang != "japanese":
            continue
        tableData = tab.find_element(By.CLASS_NAME, "wikitable")
        # should add this as the parser for booster row depending on the website - very importante
        data = []
        rows = tableData.find_elements(By.TAG_NAME, "tr")
        for i in range(len(rows)):
            if(i == 0):
                continue
            cardColumns = rows[i].find_elements(By.TAG_NAME, "td")
            cardData = {
                "cardCode": cardColumns[0].text,
                "english": cardColumns[1].text,
                "japanese": cardColumns[2].text,
                "print": cardColumns[5].text
            }
            # this follows wiki format [card num, english, japanese, rarity, type, category]

            # handling rarity
            rarityList = []
            for rarity in cardColumns[3].find_elements(By.TAG_NAME, "a"):
                rarityList.append(rarity.get_attribute("title"))
            cardData["rarity"] = rarityList

            # handling type
            typeList = []
            for type in cardColumns[4].find_elements(By.TAG_NAME, "a"):
                typeList.append(type.get_attribute("title"))
            cardData["typeList"] = typeList

            # target card url
            cardData["url"] = cardColumns[1].find_element(
                By.TAG_NAME, "a").get_attribute("href")
            data.append(cardData)

        boosterData[lang] = data
    return boosterData


def get_card_data(driver, url: str):
    # just yugipedia, im not refactoring everything now
    return None


def get_base_card_data(driver):
    wait = WebDriverWait(driver, DELAY_TIME)
    card = wait.until(EC.presence_of_element_located((By.CLASS_NAME, "card-table")))
    heading = card.find_element(By.CLASS_NAME, "heading").text
    #ignoring jap wording cuz lazy
    img = card.find_element(By.CLASS_NAME, "imagecolumn").find_element(By.TAG_NAME, "img").get_attribute("srcset")
    rowsData = card.find_element(By.CLASS_NAME, "infocolumn").find_elements(By.TAG_NAME, "tr")
    lore = card.find_element(By.CLASS_NAME, "lore").text
    cardData = {
        "english" : heading,
        "imgUrl" : img,
        "lore" : lore
    }
    for row in rowsData:
        #i am not handling different cases because theres too much specificity
        #after refactor, you are allow to do whatever u want
        field = row.find_elements(By.TAG_NAME, "th")
        value = row.find_element(By.TAG_NAME, "td").text
        if len(field) >= 1:
            cardData[field[0].text] = value
    return cardData
    
# parse yugioh yugipedia card
# baseCardUrl = "https://yugipedia.com/wiki/%22The_Sinful_Spoils_Hunter_Fiend%22"
# randomCardUrl = "https://yugipedia.com/wiki/Supreme_King_Dragon_Lightwurm"

# driver.get(randomCardUrl)
# print(json.dumps(get_base_card_data(driver), indent=2)) 


# parse booster set card list
# baseBoosterUrl = "https://yugipedia.com/wiki/Age_of_Overlord"
# randomBoosterUrl = "https://yugipedia.com/wiki/The_Lost_Millennium"

# boosterData = getCardListByBooster(driver, randomBoosterUrl)
# writeDataToFile(os.getcwd(), json.dumps(
#     boosterData, indent=2), "boosterSample.txt")


# parse all cards base on all-list
repeat_url = ""
while True:
    cache = loadFileToData(os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "cache","cache.txt"))
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
                actual_url = re.sub(r'https:\/\/yugioh\.fandom\.com\/', 'https://yugipedia.com/', cardUrl)
                if cache["curr_url"] == actual_url:
                    print("found the start url")
                    start = True
                if start == False:
                    continue
                if repeat_url == cardUrl:
                    #this means the error repeated twice, ignore it and move on
                    cache["error"] = [cardName, cardUrl]
                    continue
                cache["curr_url"] = actual_url
                try:
                    driver.get(actual_url)
                    card_data = get_base_card_data(driver)
                    writeDataToFile(writeTarget, json.dumps(card_data, indent=2), re.sub(r"[\\\/\:\*\?\"\<\>|]", "-", f'{cardName}.txt'))
                    sleep(1)               
                except Exception as e:
                    #check if it fucks up
                    repeat_url = actual_url
                    raise Exception("erroring")
            cache["finished"] = cache["finished"] + file.split(".")[0]
            cache["curr_url"] = ""
            writeDataToFile(os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "cache"),
                        json.dumps(cache),
                        "cache.txt"
                        )
            
    except Exception as e:
        print(e)
        writeDataToFile(os.path.join(os.getcwd(), BASE_DATA_DIRECTORY, YUGIOH_DIRECTORY, "cache"),
                        json.dumps(cache),
                        "cache.txt"
                        )
    


# getCardData(driver, baseCardUrl)

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
