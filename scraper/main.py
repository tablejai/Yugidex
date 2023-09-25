from time import sleep
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium import webdriver
import os

driver = webdriver.Firefox()
driver.get("https://google.com")
sleep(3)