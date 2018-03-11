# StreetCrimeUK_Shiny

## Introduction
The code presented here creates a shiny app to visualize heat maps of Street Crimes across Britain from 2010-12 to 2018-01 and test their spatial pattern.

## Usage
Please be aware that this apps downloads data from my personal Dropbox once it starts and every time the user changes some of the settings. This was the only work-around I could think of to use external data in shinyapps.io for free. However, this also makes the app a bit slowly, so please be patient.

Users can select a date with two sliders (I personally do not like the `dateInput` tool), then a crime type and click `Draw Map` to update the map with new data. I also included a option to plot the Ripley K-function (function `Kest` in package `spatstat`) and the _p-value_ of the `quadrat.test` (again from `spatstat`). Both tools work using the data shown within the screen area, so their results change as users interact with the map. The Ripley K function shows a red dashed line with the expected nearest neighbour distribution of points that are randomly distributed in space (i.e. follow a Poisson distribution). The black line is the one computed from the points shown on screen. If the black line is above the red means the observations shown on the map are clustered, while if it is below the red line means the crimes are scattered regularly in space. A more complete overview of the Ripley K function is available at this [link from ESRI](http://pro.arcgis.com/en/pro-app/tool-reference/spatial-statistics/h-how-multi-distance-spatial-cluster-analysis-ripl.htm).

The _p-value_ from the [quadrat test](https://www.rdocumentation.org/packages/spatstat/versions/1.55-0/topics/quadrat.test) is testing a null hypothesis that the crimes are scattered randomly in space, against an alternative that they are clustered. If the _p-value_ is below 0.05 (significance level of 5%) we can accept the alternative hypothesis that our data are clustered. Please be aware that this test does not account for regularly space crimes. 

## NOTE
Please not that the code here is not reproducible straight away. The app communicates with my Dropbox, though the package `rdrop2`, which requires a token to download data from Dropbox. More info [github.com/karthik/rdrop2](https://github.com/karthik/rdrop2).

I am sharing the code to potentially use a taken downloaded from elsewhere, but the `url` that points to my Dropbox will clearly not be shared.

## Preparing the dataset
Csv files with crime data can be downloaded directly from the [data.police.uk](https://data.police.uk/data/archive/) website. Please check the dates carefully, since each of these files contains more that one years of monthly data. The main issue with these data is that they are divided by local police forces, so for example we will have a csv for each month from the Bedfordshire Police, which only covers that part of the country. Moreover, these csv contain a lot of data, not only coordinates; they also contain the type of crimes, plus other details, which we do not need and which makes the full collection a couple of Gb in size.

For these reasons I did some pre-processing, First of all I extracted all csv files into a folder named "CrimeUK" and then I ran the code below:
```{r}
lista = list.files("E:/CrimesUK",pattern="street",recursive=T,include.dirs=T,full.names=T,ignore.case = T)

for(i in lista){
  DF = read.csv(i)

   write.table(data.frame(LAT=DF$Latitude, LON=DF$Longitude, TYPE=DF$Crime.type),
               file=paste0("E:/CrimesUK/CrimesUK",substr(paste(DF$Month[1]),1,4),"_",substr(paste(DF$Month[1]),6,7),".csv"),
               sep=",",row.names=F,col.names=F, append=T)
   print(i)
}
```

Here I first create a list of all csv files, with full link, searching inside all sub directory. Then I started a `for` loop to iterate through the files. The loop simply loads each file and than save part of its contents (namely coordinates and crime type) into new csv named after using year and month. This will help me identify which files to download from Dropbox, based on user inputs.

Once I had these files I simply uploded them to my Dropbox.

## Deployment to Shinyapps.io
To deploy the app on shinyapps.io I simply followed the instructions provided.

The link to test the app is:

### [fveronesi.shinyapps.io/CrimeUK](https://fveronesi.shinyapps.io/CrimeUK/)

A snapshot of the screen is below:

![Screenshot](https://github.com/fveronesi/StreetCrimeUK_Shiny/raw/master/Screenshot.jpg)
