function(){
  tabPanel("About",
           HTML("<h2> References</h2>
                <p >CO2 at surface level averaged over the Northern Hemisphere:
                Dlugokencky, E.J., K.W. Thoning, P.M. Lang, and P.P. Tans (2017), NOAA Greenhouse Gas Reference from
                Atmospheric Carbon Dioxide Dry Air Mole Fractions from the NOAA ESRL
                Carbon Cycle Cooperative Global Air Sampling Network. Data Path: ftp:
                //aftp.cmdl.noaa.gov/data/trace_gases/co2/flask/surface/</p>
                
                <p>Maximum and Minimum tempurature across Canada:
            Mekis, É. and L.A. Vincent, 2011: An overview of the second generation adjusted daily precipitation dataset for trend analysis in Canada. Atmosphere-Ocean, 49(2), 163-177.
Vincent, L. A., X. L. Wang, E. J. Milewska, H. Wan, F. Yang, and V. Swail, 2012. A second generation of homogenized Canadian monthly surface air temperature for climate trend analysis, J. Geophys. Res., 117, D18110, doi:10.1029\\/2012JD017859.
                Wan, H., X. L. Wang, V. R. Swail, 2010: Homogenization and trend analysis of Canadian near-surface wind speeds. Journal of Climate, 23, 1209-1225.
                Wan, H., X. L. Wang, V. R. Swail, 2007: A quality assurance system for Canadian hourly pressure data. J. Appl. Meteor. Climatol., 46, 1804-1817. 
                Wang, X.L, Y. Feng, L. A. Vincent, 2013. Observed changes in one-in-20 year extremes of Canadian surface air temperatures. Atmosphere-Ocean. Doi:10.1080\\/07055900.2013.818526</p>"
           ),#end of html part 1.
           #Notice that I used double quotes (") above because otherwise it would interfere with
           # the single quote in the word (don't)
           value="about"
           )
}
