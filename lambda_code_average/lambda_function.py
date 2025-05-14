import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    data = event.get("data", [])
    group_id = event.get("group_id", "unknown")

    temperatures = []

    for record in data:
        if isinstance(record, dict) and "temperature" in record:
            try:
                temp = float(record["temperature"])
                temperatures.append(temp)
            except ValueError:
                logger.warning("Nieprawidłowa temperatura: %s", record["temperature"])

    if not temperatures:
        logger.warning("Brak temperatur do obliczeń dla group_id: %s", group_id)
        average_temp = None
    else:
        average_temp = round(sum(temperatures) / len(temperatures), 2)

    logger.info("Średnia temperatura dla grupy %s: %s", group_id, average_temp)

    return {
        "group_id": group_id,
        "average_temperature": average_temp,
        "count": len(temperatures)
    }
