VOWEL_COST = 250
LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
VOWELS = 'AEIOU'


# Write the WOFPlayer class definition (part A) here
class WOFPlayer:

    def __init__(self, name):
        self.name = name
        self.prizeMoney = 0
        self.prizes = []

    def addMoney(self, amt):
        self.prizeMoney = self.prizeMoney + amt

    def goBankrupt(self):
        self.prizeMoney = 0

    def addPrize(self, prize):
        self.prizes.append(prize)

    def __str__(self):
        return "{} (${})".format(self.name, self.prizeMoney)


# Write the WOFHumanPlayer class definition (part B) here
class WOFHumanPlayer(WOFPlayer):

    def __init__(self, name):
        WOFPlayer.__init__(self, name)

    def getMove(self, category, obscuredPhrase, guessed):
        print("{} has {}".format(self.name, self.prizeMoney))
        print("Category: {}".format(category))
        print("Phrase: {}".format(obscuredPhrase))
        print("Guessed: {}".format(guessed))
        print("Guess a letter, phrase, or type 'exit' or 'pass':")
        return input()


# Write the WOFComputerPlayer class definition (part C) here
class WOFComputerPlayer(WOFPlayer):
    """ class to represent Wheel of Fortune Computer Player. """
    # WOFComputerPlayer is a subclass of WOFPlayer
    # WOFComputerPlayer "inherits" variables (both instance and class variables)
    # and methods from WOFPlayer. This is done by inserting WOFPlayer in the parentheses.

    # class variable -> SORTED_FREQUENCIES
    SORTED_FREQUENCIES = 'ZQXJKVBPYGFWMUCLDRHSNIOATE'

    def __init__(self, name, difficulty):  # constructor with extra parameter difficulty (an instance variable)
        WOFPlayer.__init__(self,
                           name)  # bring in parent's class constructor along with its instance variables 'name', 'prizeMoney', and 'prizes
        self.difficulty = difficulty

    # smartCoinFlip method -> Helps us to decide semi-randomly whether to make a 'good' or 'bad' move
    def smartCoinFlip(self):
        rand_number = random.randint(1, 10)  # pick random number between 1 and 10 -> assign it to 'rand_number'
        if rand_number > self.difficulty:  # return 'True' if 'rand_number' is greater than 'self.difficulty'
            return True  # return 'True'...ComputerPlayer makes a 'good' move
        else:  # return 'False' if 'rand_number' is less than or equal to 'self.difficulty'
            return False  # return 'False'...ComputerPlayer makes a 'bad' move

    # getPossibleLetters method -> This method should return a list of letters that can be guessed
    def getPossibleLetters(self, guessed):
        canBeGuessed = []  # create empty list stored in canBeGuessed

        # all letters including vowels in list if ComputerPlayer has equal or over $250 of prizeMoney
        if self.prizeMoney >= VOWEL_COST:
            for x in LETTERS:
                if x not in guessed:
                    canBeGuessed.append(x)
        # all letters not including vowels in list if ComputerPlayer has less than $250 of prizeMoney
        else:
            for x in LETTERS:
                if x not in VOWELS:
                    if x not in guessed:
                        canBeGuessed.append(x)
        # return list of letters depending on if ComputerPlayer has $250 of prizeMoney or has less than $250 of prizeMoney
        return canBeGuessed

        # getMove method -> This method should return a valid (correct) move

    def getMove(self, category, obscuredPhrase, guessed):
        # use the getPossibleLetters(self, guessed) method above
        canBeGuessed = self.getPossibleLetters(
            guessed)  # call getPossibleLetters() method -> Returns list of characters that can be guessed
        # use the smartCoinFlip() method above
        moveType = self.smartCoinFlip()  # call smartCoinFllip() method -> Returns either 'True' or 'False' for 'good' move or 'bad' move

        # if there aren't any letters that can be guessed, return 'pass'
        # this works in the case that canBeGuessed contains 'VOWELS' but ComputerPlayer has less than $250 to use them
        for x in canBeGuessed:
            if x in VOWELS and self.prizeMoney < VOWEL_COST:
                return 'pass'

        if moveType == True:  # ComputerPlayer makes 'good' move
            for char in self.SORTED_FREQUENCIES[::-1]:  # check for 'char' at end of list (most frequent)
                if char in canBeGuessed:
                    return char  # return most frequent possible character -> This is what computer player picks

        else:  # ComputerPlayer makes 'bad' move
            return random.choice(canBeGuessed)  # return random character from set of possible charcters

        # Check that there aren't any letters that can be guessed:
        if len(canBeGuessed) == 0:
            return 'pass'