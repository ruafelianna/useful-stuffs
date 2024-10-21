#!/usr/bin/python

import telebot
import uuid
from datetime import datetime, timezone, timedelta

# настройки

API_TOKEN = 'YOUR_TOKEN'
DEBUG = True

# бот

bot = telebot.TeleBot(API_TOKEN)

# данные

a_complaint = 'complaint'
a_question = 'question'
a_suggestion = 'suggestion'

appeals = {
    a_complaint: 'Жалоба',
    a_question: 'Вопрос',
    a_suggestion: 'Предложение',
}

prompts = {
    a_complaint: 'свою жалобу',
    a_question: 'свой вопрос',
    a_suggestion: 'своё предложение',
}

chats = {
    a_complaint: YOUR_CHAT_ID,
    a_question: YOUR_CHAT_ID,
    a_suggestion: YOUR_CHAT_ID,
}

btn_cancel = 'cancel'
c_cancel = 'Отменить'

# кнопки

kbAppealType = telebot.types.InlineKeyboardMarkup()
for key, value in appeals.items():
    kbAppealType.add(telebot.types.InlineKeyboardButton(value, callback_data=key))

kbCancel = telebot.types.InlineKeyboardMarkup()
kbCancel.add(telebot.types.InlineKeyboardButton(c_cancel, callback_data=btn_cancel))

# безопасность

def ignore_bots(func):
    def inner(message):
        if not message.from_user.is_bot:
            return func(message)
    return inner

# отладка

@bot.message_handler(commands=['debug'])
def send_start(message):
    if DEBUG:
        bot.send_message(message.from_user.id, message.chat.id)

# обработка команд

@bot.message_handler(commands=['start'])
@ignore_bots
def send_start(message):
    bot.send_message(message.from_user.id, f"""\
Здравствуйте, {message.from_user.username}! Я бот-помощник по обращениям.
Используйте команду /help, чтобы увидеть, что я умею.\
""")


@bot.message_handler(commands=['help'])
@ignore_bots
def send_help(message):
    commands = '\n'.join(
        [f"/{cmd.command} - {cmd.description}" for cmd in bot.get_my_commands()]
    )
    bot.send_message(message.from_user.id, f"""\
Список доступных команд:
{commands}\
""")


@bot.message_handler(commands=['appeal'])
@ignore_bots
def send_appeal(message):
    bot.send_message(message.from_user.id, "Выберите тип обращения:", reply_markup=kbAppealType)

# обработка кнопок

@bot.callback_query_handler(func=lambda call: call.data in appeals)
def process_appeal_type(call):
    msg = bot.edit_message_text(
        f"""\
Введите {prompts[call.data]}.

К сообщению допустимо добавить одно вложение. Остальные вложения отправлены не будут.
""",
        call.message.chat.id,
        call.message.message_id,
        reply_markup=kbCancel
    )
    bot.register_next_step_handler(msg, process_question, call.data, msg)


@bot.callback_query_handler(func=lambda call: call.data == btn_cancel)
def process_cancel(call):
    bot.clear_step_handler(call.message)
    bot.edit_message_text(
        "Отправка обращения отменена",
        call.message.chat.id,
        call.message.message_id
    )

# обработка обращения

def process_question(message, type, bot_msg):
    chat = chats[type]
    appeal_id = uuid.uuid4()
    now = datetime.utcnow() + timedelta(hours=3)

    msg_info = f"""\
ID обращения: {appeal_id}
Тип обращения: {appeals[type]}
Время обращения: {now} MSK\
"""

    user_info = f"""\
Фамилия: {message.from_user.last_name}
Имя: {message.from_user.first_name}
Имя пользователя: @{message.from_user.username}
Язык: {message.from_user.language_code}\
"""

    new_msg_id = bot.copy_message(chat, message.chat.id, message.id).message_id

    try:
        bot.edit_message_text(f"""\
{msg_info}
{user_info}
-------------------------------
{message.text}\
""", chat, new_msg_id)
    except:
        bot.edit_message_caption(f"""\
{msg_info}
{user_info}
-------------------------------
{message.caption}\
""", chat, new_msg_id)

    bot.edit_message_text(f"""\
Ваше обращение передано ответственному лицу.
---------------------------------------------
{msg_info}\
""", bot_msg.chat.id, bot_msg.message_id)

# запуск сервера

bot.infinity_polling()
