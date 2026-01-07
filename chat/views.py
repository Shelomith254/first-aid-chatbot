from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import os
from openai import OpenAI
from django.contrib.auth.decorators import login_required

@login_required(login_url='login')
@csrf_exempt
def chat_view(request):
    username = request.user.username

    if request.method == "POST":
        user_message = request.POST.get("prompt", "")

        if user_message:
            try:
                client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

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
                                "Always keep your answers brief, clear, and actionable."
                            )
                        },
                        {"role": "user", "content": user_message}
                    ]
                )

                bot_response = response.choices[0].message.content

            except Exception as e:
                bot_response = "Service temporarily unavailable."

            return JsonResponse({"response": bot_response})

    return render(request, "chat/chat.html", {"username": username})
