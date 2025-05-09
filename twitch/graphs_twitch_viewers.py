from matplotlib import pyplot as plt
import numpy as np
import pandas as pd

# Bar Graph: Featured Games

games = ["LoL", "Dota 2", "CS:GO", "DayZ", "HOS", "Isaac", "Shows", "Hearth", "WoT", "Agar.io"]

viewers =  [1070, 472, 302, 239, 210, 171, 170, 90, 86, 71]

plt.bar(range(len(games)), viewers, color='blue')

plt.legend(['Most popular games on Twitch'])
plt.xlabel('Games')
plt.ylabel('Viewers')

ax = plt.subplot()
ax.set_xticks(range(0, 10))
ax.set_xticklabels(games, rotation=30)

plt.show()
# this is to clear current figure before creating next figure (pie chart)
plt.clf()

# Pie Chart: League of Legends Viewers' Whereabouts

labels = ["US", "DE", "CA", "N/A", "GB", "TR", "BR", "DK", "PL", "BE", "NL", "Others"]

countries = [447, 66, 64, 49, 45, 28, 25, 20, 19, 17, 17, 279]

colors = ['lightskyblue', 'gold', 'lightcoral', 'gainsboro', 'royalblue', 'lightpink', 'darkseagreen', 'sienna', 'khaki', 'gold', 'violet', 'yellowgreen']

explode = (0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)


plt.pie(countries, explode=explode, colors=colors, shadow=True, startangle=345, autopct='%1.0f%%', pctdistance=1.15)

plt.title("League of Legends Viewers' Whereabouts")
plt.legend(labels, loc="right")

plt.show()

plt.clf()

# Line Graph: Time Series Analysis

hour = range(24)

viewers_hour = [30, 17, 34, 29, 19, 14, 3, 2, 4, 9, 5, 48, 62, 58, 40, 51, 69, 55, 76, 81, 102, 120, 71, 63]

y_upper = [1.15*n for n in viewers_hour]
y_lower = [0.85*n for n in viewers_hour]

plt.plot(hour, viewers_hour)
plt.fill_between(hour, y_upper, y_lower, alpha=0.2)

ax = plt.subplot()
ax.set_xticks(hour)
ax.set_yticks([0, 20, 40, 60, 80, 100, 120])

plt.title('Views per Hour')
plt.xlabel('Hour')
plt.ylabel('Viewer Numbers')
plt.legend(['2015-01-01'])

plt.show()
