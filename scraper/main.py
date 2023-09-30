from time import sleep
from path import Path
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import json
import os

DELAY_TIME = 10
DELAY_TIME_MS = DELAY_TIME * 1000
BASE_DATA_DIRECTORY = "data"
YUGIOH_DIRECTORY = "yugioh"


driver = webdriver.Firefox()

def writeDataToFile(path: str, data: str, fileName: str):
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

alphabeticalList = "abcdefghijklmnopqrstuvwxyz¡"
base_url = "https://yugioh.fandom.com/wiki/Category:OCG_cards"

# for chr in alphabeticalList:
#     getCardListByAlphabet(driver, f"https://yugioh.fandom.com/wiki/Category:OCG_cards?from={chr}")
#     sleep(10)
current_url = base_url
while True:
    getCardListByAlphabet(driver, current_url)
    try:
        button = driver.find_element(By.CLASS_NAME, "category-page__pagination-next")
        current_url = button.get_attribute("href")
    except Exception as e:
        print("it break")
        print(e)
        break




