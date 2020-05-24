# hogai - an AI Groundhog

Groundhog's Day is a popular American holiday in the US. On February 2 of every year, thousands of citizens gather in Punxsutawney, Pennsylvania to see Punxsutawney Phil, a groundhog, predict the arrival of spring.

In today's modern age, it is widely known that Phil is not the best at forecasting the coming of spring. In fact, he is only able to correctly predict the arrival of spring about [35-40% of the time](https://www.ncei.noaa.gov/news/groundhog-day-forecasts-and-climate-history).

In more recent years, animal-rights groups such as [PETA have been calling for animatronic and AI groundhogs to replace Punxsutawney Phil](https://www.theverge.com/2020/1/30/21114868/punxsutawney-phil-replaced-ai-animatronic-groundhog-says-peta) (who is also immortal, according the tradition).

Here we present, hogai, an artificial intelligence trained to predict whether Punxsutawney Phil will see his shadow. Hogai is a random forest trained on historical data from previous years of Groundhog's Day. We used [historical weather data features](https://www.ncdc.noaa.gov/cdo-web/) such as temperature, wind speeds, and cloud conditions from over forty years of Groundhog's Days in Punxsutawney, PA. Hogai obtained perfect accuracy on its training data and is able to correctly predict 4/5 of the outcomes of heldout historical data that it was not trained on.


You can check out hogai [here](https://alecmchiu.shinyapps.io/hogai/). 


