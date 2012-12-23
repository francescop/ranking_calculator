require 'rubygems'
require 'sinatra'

get '/' do
	"
	<form id='form' action=search method=post>
		<label>site: </label><input name='site'></input></br>
		<label>keyword: </label><input name='keyword'></input></br>
		<input type='radio' name='language' value='it' checked>Italian Google</br>
		<input type='radio' name='language' value='us'>US Google</br>
		</br>
		<input type='radio' name='render' value='html' checked>Html Output</br>
		<input type='radio' name='render' value='text'>Text Output</br>
		<button>submit</button>
	</form>
	"
end

post '/search' do
	result = `ruby /home/dino/Desktop/rankingcalculator.rb "#{params[:site]}" "#{params[:keyword]}" "#{params[:language]}" "#{params[:render]}"`
	"
	ricerca per il sito: #{params[:site]} </br> 
	recerca la keyword: #{params[:keyword]} </br>
	" + result

end
