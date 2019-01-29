**The Last Improvement**

We were quite happy with the deployed app so far but as it is rightly said if you have a curious mind there is always more. We wanted to explore how to bring about the attention of the user towards using the app. As Cydney discussed during the last lecture, the user will be more interested in using the app if he/she seems connected to the task accomplished by the app.
Earlier we had a generic tagline which we changed to more user centric. Now are app has a question for the user.  <br>
**Has your locality been safe in the past ?  Check it out yourself.**<br>
This tagline targets the audience especially if they are moving to a new house lets say. Before making the move they can check out how the crime situation in their locality been.

Another nice to have feature which we were suggested by our peers during the feedback session was for the user to be able to hover over the plots and get the value for the number of incidents of crime in the area selected. We worked quite a bit to implement this feature and finally we were successful.

We had challenges implementing the hover feature mainly because we had everything prepared in the ``ggplot2`` package. We tried a couple of packages but after a valuable suggestion from Vincenzo we tried to wrap everything in the ``plotly``. We struggled a bit but eventually got the way we wanted our app to be. This is how the hover feature looks like :

|    Hover over Line plot          | Hover over Bar plot |
|-------------------------:|:-------------------------|
![](/figure/Hover_Image1.PNG)  |  ![](/figure/Hover_Image2.png)

Now that we have our app working, if we had more time and the flexibility to work from scratch we would want to use the USA map in the app as well. We wish to have the interactive user map where hovering over each of the state shows us the data about the crime situation in the state.
