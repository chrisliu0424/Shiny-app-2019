function(){
	tabPanel("About",
		HTML("<h1> Junchao(Chris) Liu</h1>
        <p >This project aims to illustrate the climate change in Vancouver Area using evidences.</p>
		
		     "
		),#end of html part 1.
		
        #Notice that I used double quotes (") above because otherwise it would interfere with
        # the single quote in the word (don't)
        HTML('
        <div style="clear: left;">
        <img src="Chris_Profile.jpeg" alt="" style="height: 274px; width: 204px; "> </div>
        <p>
        Junchao(Chris) Liu</a><br>
        Major:Statistics<br>
        Minor:Computer Science<br>
        Simon Fraser University<br>
        <a href="https://github.com/chrisliu0424/Shiny-app-2019.git" target="_blank">Github</a><br>
        <a href="www.linkedin.com/in/junchao-chris-liu-28b259175" target="_blank">Linkedin</a> <br/>
        </p>'),#End of html part 2
		value="about"
	)
}
