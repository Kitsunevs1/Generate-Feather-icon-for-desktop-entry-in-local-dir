import os
import time
import subprocess
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

# Configuration
VIDEO_PATH = "original.mp4"  # Your base video
OUTPUT_PATH = "output.mp4"
DAYS = 100
USERNAME = "your_tiktok_username"
PASSWORD = "your_tiktok_password"
CRYPTO_ADDRESS = "your_crypto_wallet_address"  # Optional

# Function to add text overlay to video
def add_text_to_video(day):
    text = f"Send me crypto! Day #{day}"
    cmd = (
        f'ffmpeg -i {VIDEO_PATH} -vf "drawtext=text=\'{text}\':x=10:y=10:fontsize=50:fontcolor=white" '
        f"-codec:a copy {OUTPUT_PATH} -y"
    )
    subprocess.run(cmd, shell=True)

# TikTok Auto Upload
def upload_video(day):
    driver = webdriver.Chrome()  # Use the correct WebDriver
    driver.get("https://www.tiktok.com/upload")
    time.sleep(5)

    # Login
    driver.find_element(By.NAME, "username").send_keys(USERNAME)
    driver.find_element(By.NAME, "password").send_keys(PASSWORD + Keys.RETURN)
    time.sleep(5)

    # Upload video
    file_input = driver.find_element(By.XPATH, "//input[@type='file']")
    file_input.send_keys(os.path.abspath(OUTPUT_PATH))
    time.sleep(10)

    # Set title
    title_box = driver.find_element(By.CLASS_NAME, "public-DraftEditor-content")
    title_box.send_keys(f"Send me crypto! Day #{day} - {CRYPTO_ADDRESS}")  # Title

    # Post
    post_button = driver.find_element(By.XPATH, "//button[contains(text(), 'Post')]")
    post_button.click()

    driver.quit()

# Run for 100 days
for day in range(1, DAYS + 1):
    add_text_to_video(day)  # Modify video with text
    upload_video(day)  # Upload to TikTok
    time.sleep(86400)  # Wait a day
