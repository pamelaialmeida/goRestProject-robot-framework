# goRestProject-robot-framework

# 1. Install Python 3 
	1.1. Go to https://www.python.org/downloads/
	1.2. Download Python 3
	1.3. Run the installer, choose the option "Add Python 3 to PATH" and choose option "Install Now"
	1.4. After finished, open the command prompt, type the command "python --version" and press enter. It will show your installed python version

# 2. Install Chrome driver
	2.1. Go to https://chromedriver.chromium.org/downloads
	2.2. Download the chromedriver version for your chrome browser (Check your Chrome browser version on "..." > "Help" > "About Google Chrome")
	2.3. Unzip the file downloaded
	2.4. Put the chromedrive in the directory C:\Users\{user}\AppData\Local\Programs\Python\Python{version}\Scripts

# 3. Install Robot Framework
	3.1. Open a command prompt and run the command "pip install robotframework"

# 4. Install used libraries
	4.1. Open a command prompt and run the command "pip install robotframework-requests"
	4.2. Open a command prompt and run the command "pip install robotframework-faker"

# 5. To run tests:
  5.1. Download the project
  5.2. Open a command prompt, access the project directory, and run the command "robot -d /results src/test"
