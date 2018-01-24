from __future__ import print_function
import os
import json
import zipfile
import shutil
import sys


import urllib #import urlretrieve, urlopen

#def downloadFile(url, outFile):
#    urlretrieve(url, outFile)

def isNewer(new, original):
    majorMult, minorMult, patchMult = 10000,100,1
    major1, minor1, patch1 = original.split('.')
    major2, minor2, patch2 = new.split('.')
    return majorMult * major2 + minorMult * minor2 + patchMult * minor2 > majorMult * major1 + minorMult * minor1 + patchMult * minor1


def downloadProgress(count, blockSize, totalSize):
    if count % 1000 == 0:
        percentDone = float(count) * blockSize / totalSize * 100.0
        print("%4.2f%%" % percentDone,end='\b\b\b\b\b\b')

def main():
    currentInstallFileName = "viewer_currentInstall.json"

    versionAndChangeLogUrl = "http://s3.amazonaws.com/battlecode-2018/viewer/"

    versionFileName = "version.txt"
    changelogFileName = "changelog.json"

    baseUrl = "http://s3.amazonaws.com/battlecode-2018/viewer/"

    directory = os.path.dirname(os.path.realpath(__file__))

    zipFileName = "viewer_latest.zip"
    viewerDirectory = "viewer_latest/"

    currentInfoFileLocation = os.path.join(directory, currentInstallFileName)
    if os.path.exists(currentInfoFileLocation):
        currentInfoFile = open(currentInfoFileLocation)
        currentInfo = json.load(currentInfoFile)
        currentInfoFile.close()
    else:
        possibleSystems = [
            ("1", "Windows (64-bit)", "Win64"),
            ("2", "Windows (32-bit)", "Win32"),
            ("3", "Linux (64-bit)", "Linux64"),
            ("4", "Linux (32-bit)", "Linux32"),
            ("5", "Mac OS X", "Mac")
        ]
        print("It looks like this is your first time installing the viewer. What system are you using?")
        for optionNum, optionName, actualName in possibleSystems:
            print("%s) %s" % (optionNum, optionName))
        systemInp = raw_input("> ")
        try:
            systemInp = int(systemInp)
            if systemInp <= 0 or systemInp > len(possibleSystems):
                raise Exception()
            currentInfo = {
                'version': '0.0.0',
                'system': possibleSystems[systemInp - 1][2]
            }
            print("Done setup! You've selected the system %s. \nIf you ever want to change this setup, delete the file %s " % (possibleSystems[systemInp-1][1], currentInstallFileName))
        except:
            print("Invalid input. Exiting..")
            sys.exit(1)
        

    versionFileUrl = versionAndChangeLogUrl + versionFileName
    latestVersion =  urllib.urlopen(versionFileUrl).read().decode()

    print("Checking for updates...")

    if isNewer(latestVersion, currentInfo['version']):
        print("There is a newer version available.\nCurrent version is: %s. The new version is %s." % (currentInfo['version'], latestVersion))
    else:
        print("No updates! Would you like to reinstall the viewer anyway?")
    shouldDownload = raw_input("Download? (Y/N) > ").lower() == "y"
    if shouldDownload:
        newestUrl = baseUrl + ("%s/%s.zip" % (latestVersion, currentInfo['system']))
        downloadLocation = os.path.join(directory, zipFileName)
        if os.path.exists(downloadLocation):
            print("Removing previous archive...")
            os.remove(downloadLocation)
            print("Deleted old archive.")
        print("Downloading new client... This could take a while.")
        urllib.urlretrieve(newestUrl, downloadLocation, downloadProgress)
        print()
        print("Successfully downloaded files. ")
        outputDirectory = os.path.join(directory, viewerDirectory)
        if os.path.exists(outputDirectory):
            print("Removing previous client")
            shutil.rmtree(outputDirectory, True)
            print("Successfully removed previous client.")
        print("Extracting from archive...")
        zip_ref = zipfile.ZipFile(downloadLocation, "r")
        zip_ref.extractall(outputDirectory)
        zip_ref.close()
        print("Extracted fully!")
        if os.path.exists(downloadLocation):
            print("Cleaning up downloads...")
            os.remove(downloadLocation)
            print("Cleaned up")
        try:
            if currentInfo['system'] == 'Linux32':
                print("Fixing permissions...")
                print("chmod 777 viewer_latest/Linux32/battleclient18.x86")
                os.system("chmod 777 viewer_latest/Linux32/battleclient18.x86")
                print("Done fixing permissions!")
            elif currentInfo['system'] == 'Linux64':
                print("Fixing permissions...")
                print("chmod 777 viewer_latest/Linux64/battleclient18.x86_64")
                os.system("chmod 777 viewer_latest/Linux64/battleclient18.x86_64")
                print("Done fixing permissions!")
            if currentInfo['system'] == 'Mac':
                print("Fixing permissions...")
                print("chmod -R 777 viewer_latest/Mac/battleclient18.app")
                os.system("chmod -R 777 viewer_latest/Mac/battleclient18.app")
                print("Done fixing permissions!")
        except:
            pass
        print("Updating current version number...")
        newInfo = {}
        newInfo['version'] = latestVersion
        newInfo['system'] = currentInfo['system']
        currentInfoFile = open(currentInfoFileLocation, "w")
        currentInfo = json.dump(newInfo, currentInfoFile)
        currentInfoFile.close()
        print("All set! The viewer is in: %s" % outputDirectory)
    else:
        print("Not downloading - your system has not been changed.")

if __name__ == "__main__":
    main()


