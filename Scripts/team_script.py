import requests
import json

def write_text(data: str, path: str):
    with open(path, 'w') as file:
        file.write(data)

def saveSVG(imgUrl: str, id: str):
    svg = requests.get(f'https://nbacolors.com/img/logos/{imgUrl.replace(" ", "%20")}').text
    write_text(svg, f'{id}.svg')

# Request NBA colors JSON
response = requests.get("https://nbacolors.com/js/data.json")
for team in response.json():
    saveSVG(team["img"], team["team"].replace(" ", "_"))