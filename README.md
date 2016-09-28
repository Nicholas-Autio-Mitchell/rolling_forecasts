<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Twitter as a source of data for rolling forecasts</a>
<ul>
<li><a href="#sec-1-1">1.1. Future improvements</a></li>
</ul>
</li>
</ul>
</div>
</div>

# Twitter as a source of data for rolling forecasts<a id="sec-1" name="sec-1"></a>

The first part of this project is to create a start-to-finish prototype, which starts by obtaining and cleaning Twitter data for given search terms. This Twitter data should then be combined with other readily available data, such as financial markets or weather. This may include some further analysis on the obtained data, such as NLP methods e.g. sentiment analysis. 
This should all be as automated as far as possible.

The final goal is to use this data pipeline to then produce input for forecasting models, which learn over time as more data is provided (time-series progression). The forecasting should also then be automated to a high degree.

## Future improvements<a id="sec-1-1" name="sec-1-1"></a>

Are there any developments in scraping, in the direction of headless browsing? Can Twitter's advanced search be used via GhostDriver or Selenium "headlessly", thereby decreasing the run-time for a given target?