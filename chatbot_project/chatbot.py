from openai import OpenAI
import os
from dotenv import load_dotenv

# Load the .env file
load_dotenv()

# Get the API key from environment
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")

# Initialize client with env variable
client = OpenAI(api_key=OPENAI_API_KEY)

def chat_with_bot(user_input):
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": user_input}
        ]
    )
    return response.choices[0].message.content

if __name__ == "__main__":
    user_message = input("You: ")
    bot_reply = chat_with_bot(user_message)
    print("Bot:", bot_reply)
