from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import os
from openai import OpenAI
from dotenv import load_dotenv
from django.contrib.auth.decorators import login_required

load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

@login_required(login_url='login')
@csrf_exempt
def chat_view(request):
    username = request.user.username

    if request.method == "POST":
        user_message = request.POST.get("prompt", "")
        if user_message:
            try:
                # NEW correct syntax for OpenAI client >= 1.0
                response = client.chat.completions.create(
                    model="gpt-3.5-turbo",
                    messages=[
                        {
                            "role": "system",
                            "content": (
                                "You are a First Aid assistant. "
                                "You only provide information about First Aid procedures, "
                                "symptoms, and emergency responses. "
                                "Do NOT answer questions outside of First Aid. "
                                "Always keep your answers brief, clear, and actionable. "
                                "If asked something unrelated, reply politely: "
                                "'I am a First Aid assistant and cannot answer that.'"
                            )
                        },
                        {"role": "user", "content": user_message}
                    ]
                )
                
                # ACCESS the message content correctly
                bot_response = response.choices[0].message.content

            except Exception as e:
                bot_response = f"Error: {str(e)}"

            return JsonResponse({"response": bot_response})

    return render(request, "chat/chat.html", {"username": username})
