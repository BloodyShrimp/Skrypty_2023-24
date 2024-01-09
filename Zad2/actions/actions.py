# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions

from typing import Any, Text, Dict, List
import json
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import re

class ActionAddress(Action):
    def name(self) -> Text:
        return "action_address"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        address = tracker.get_slot("address")

        if address:
            dispatcher.utter_message(f"Your order will be delivered to: {address}")
        else:
            dispatcher.utter_message("No address found.")

        return []
    
class ActionSummarizeOrder(Action):
    def name(self) -> Text:
        return "action_summarize_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open("menu.json", "r") as file:
            menu = json.load(file)["items"]

        order_details = []
        order_list = list(tracker.get_latest_entity_values("order"))

        if len(order_list) == 0:
            dispatcher.utter_message(text=f"I couldn't understand your order. Try again.")
            return []

        for order_info in order_list:
            quantity = 1
            special_request = ""
            dish_not_found = True

            for item in menu:
                if item['name'].lower() in order_info.lower():
                    dish_not_found = False
                    dish_info = item['name']
                    quantity_match = re.search(r"\b(\d+)\b", order_info)
                    if quantity_match:
                        quantity = int(quantity_match.group(1))
                    special_request = order_info.replace(str(quantity), "").replace(dish_info, "").replace(dish_info.lower(), "").strip()

            if dish_not_found:
                dispatcher.utter_message(text=f"I couldn't recognize one of the dishes. Try again.")
                return []

            order_details.append({
                "dish": dish_info,
                "quantity": quantity,
                "special_request": special_request,
            })

        order_summary_message = "Okay, your order is:\n"
        for order in order_details:
            order_summary_message += f"{order['quantity']} {order['dish']}"
            if order['special_request']:
                order_summary_message += f" ({order['special_request']})"
            order_summary_message += "\n"

        total_price = 0
        preparation_time = 0

        for order in order_details:
            dish = next((item for item in menu if item["name"].lower() == order["dish"].lower()), None)
            if dish:
                total_price += dish["price"] * order["quantity"]
                preparation_time += dish["preparation_time"] * 60 * order["quantity"]

        order_summary_message += f"\nTotal price: ${total_price:.2f}\nPreparation time: {preparation_time:.0f} minutes"
        dispatcher.utter_message(text=order_summary_message)
        dispatcher.utter_message(text="Would you like takeout or delivery?")

        return []

class ActionOpenHours(Action):
    def name(self) -> Text:
        return "action_open_hours"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        with open("opening_hours.json", "r") as file:
            opening_hours_data = json.load(file)

        day_entity = next(tracker.get_latest_entity_values("day"), None)
        hour_entity = next(tracker.get_latest_entity_values("hour"), None)

        if not day_entity and not hour_entity:
            all_hours_str = "\n".join([f"{day}: {data['open']} to {data['close']}" for day, data in opening_hours_data["items"].items()])
            dispatcher.utter_message("The opening hours are as follows:\n{}".format(all_hours_str))
            return []

        day_entity = day_entity.title() if day_entity else None

        if day_entity and hour_entity:
            if day_entity in opening_hours_data["items"]:
                open_hour = int(opening_hours_data["items"][day_entity]["open"])
                close_hour = int(opening_hours_data["items"][day_entity]["close"])
                if open_hour <= int(hour_entity) <= close_hour:
                    dispatcher.utter_message("Yes, we are open at {} on {}.".format(hour_entity, day_entity))
                else:
                    dispatcher.utter_message("No, we are closed at {} on {}.".format(hour_entity, day_entity))
            else:
                dispatcher.utter_message("Sorry, we don't have information about the opening hours for {}.".format(day_entity))
        else:
            if day_entity and day_entity in opening_hours_data["items"]:
                open_hour = int(opening_hours_data["items"][day_entity]["open"])
                close_hour = int(opening_hours_data["items"][day_entity]["close"])
                if open_hour == 0 and close_hour == 0:
                    dispatcher.utter_message("The restaurant is closed on {}.".format(day_entity))
                else:
                    dispatcher.utter_message("The restaurant is open from {} to {} on {}.".format(open_hour, close_hour, day_entity))
            else:
                dispatcher.utter_message("Sorry, we don't have information about the opening hours for {}.".format(day_entity))

        return []
    
class ActionShowMenu(Action):
    def name(self) -> Text:
        return "action_show_menu"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        with open('menu.json', 'r') as file:
            menu_data = json.load(file)

        menu_items = menu_data.get('items', [])

        message = "Here is our menu:\n"
        for item in menu_items:
            preparation_time_minutes = int(item['preparation_time'] * 60)
            message += f"{item['name']} - ${item['price']} - {preparation_time_minutes} mins\n"

        dispatcher.utter_message(message)

        return []