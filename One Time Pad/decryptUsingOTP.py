fileToDecrypt = input("File to decrypt is: ")
outputFilename = input("Output file name (with extension): ")
padFile = input("Pad file is: ")
padOffset = int(input("Pad offset: "))
with open(fileToDecrypt, "rb") as f:
    with open(padFile, "rb") as pad:
        with open(outputFilename, "wb") as outputFile:
            for byte, padByte in zip(f.read(), pad.read()[padOffset:]):
                outputFile.write(((byte - padByte) % 256).to_bytes(1, byteorder='big'))
print("Success, generated: " + outputFilename)
