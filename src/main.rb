# frozen_string_literal: true
require 'selenium-webdriver'
require './src/modules/convert.rb'
require './src/modules/keyboard.rb'

CssConverter = Convert::CSS.new

driver = Selenium::WebDriver.for :chrome
driver.get "https://typing.playgram.jp/assessment"

driver.find_elements(:css, '.cookie-consent-close')[0].click # クッキー
sleep 1

driver.find_elements(
  :css,
  CssConverter.ClassToSelector(
    class_names='MuiButtonBase-root MuiButton-root MuiButton-contained MuiButton-containedPrimary MuiButton-sizeMedium MuiButton-containedSizeMedium MuiButton-root MuiButton-contained MuiButton-containedPrimary MuiButton-sizeMedium MuiButton-containedSizeMedium css-1m1hlo3'
  )
)[0].click
sleep 1

typing " "

loop do
  word_element = driver.find_elements(
   :css,
   "#__next > div > div.content-main.wrap-keyboard > div.MuiGrid-root.MuiGrid-container.css-1d3bbye > div.MuiGrid-root.MuiGrid-item.MuiGrid-grid-xs-9.css-14ybvol > div > div > div > div:nth-child(3) > div"
  )

  if word_element.length == 0
    puts "End"
    sleep 1000
  end

  word = word_element[0].text.strip

  while word.include? "\n"
    word = word.sub("\n", '')
  end

  word = word.downcase
  puts word

  typing word
  sleep 0.1
end