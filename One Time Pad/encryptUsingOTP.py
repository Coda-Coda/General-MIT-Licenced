fileToEncrypt = input("File to encrypt is: ")
outputFilename = input("Output file name: ")
padFile = input("Pad file is: ")
padOffset = int(input("Pad offset: "))
with open(fileToEncrypt, "rb") as f:
    with open(padFile, "rb") as pad:
        with open(outputFilename, "wb") as outputFile:
            fContents = f.read()
            padContents = pad.read()[padOffset:]
            if (len(fContents) > len(padContents)):
                raise Exception("Pad is too short to encrypt this file")
            for byte, padByte in zip(fContents, padContents):
                outputFile.write(((byte + padByte) % 256).to_bytes(1, byteorder='big'))
            print("Success, generated: " + outputFilename + " \nYour new minimum pad offset is: " + str(padOffset + len(fContents)))
