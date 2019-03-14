# DigitalEnablerHackathon
We created a system that allows to different users that are living on a city to report different problematics on their living areas like: noise, air contamination, water quality...

We have two components:
- A dashboard that shows every alert with water and air contamination.
- An application that allows to create alerts.

## Dashboard
We are using [Digital Enabler Platform](digitalenabler.eng.it) for creating the dashboard and connecting the different datasets.
Features:
- Overview of the alerts from the users. 
- It shows air quality and noise around the city on a map.

## Datasource

We have two different sources:
- The users can report air/noise problems via a mobile application. In this case, the user can rate the issue from 1 to 10
and include a small description of the problem.
- To measure the quality of the air, we have created a new datasource based on the https://breezometer.com/ API. In this case, we take the longitude and latitude as inputs (with a constant key) and the output will be a value from 0 to 100 that defines the Air Quality.

## App
The application is made using Flutter, a cross platform mobile app development framework.
Features:
- The application allows people to signal problems in construction sites or at industrial locations that have been registerd in the system.
- The problems can be for example air quality problems or noise problems.
- It should be used by people to report any issues during production or development.
- The issues are reported to the platform where their are visualized.
