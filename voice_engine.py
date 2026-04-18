import pyttsx3
import speech_recognition as sr

class VoiceEngine:
    def __init__(self):
        self.r = sr.Recognizer()

    def speak(self, text):
        try:
            engine = pyttsx3.init()
            engine.setProperty('rate', 180)
            engine.say(text)
            engine.runAndWait()
            engine.stop()
        except:
            pass

    def listen(self):
        with sr.Microphone() as source:
            try:
                audio = self.r.listen(source, timeout=5, phrase_time_limit=8)
                return self.r.recognize_google(audio)
            except:
                return None