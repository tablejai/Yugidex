from itertools import islice
def unicodeToJapanese(unicodeStr : str):
    japanese_text = unicodeStr.replace("「", "").replace("」", "")
    splitted_japanese_text = japanese_text.split("\n")

    lowerText = "".join(islice(splitted_japanese_text, 0, None, 2))
    upperText = "".join(islice(splitted_japanese_text, 1, None, 2))
    return [lowerText, upperText]