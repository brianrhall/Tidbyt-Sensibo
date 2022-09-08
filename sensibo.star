load("render.star", "render")
load("encoding/base64.star", "base64")
load("http.star", "http")

SENSIBO_INFO_API = "https://home.sensibo.com/api/v2/users/me/pods?fields=*&apiKey=API_KEY"

SENSIBO_IMG = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABcAAAAgCAYAAAD5VeO1AAAAAXNSR0IArs4c6QAAAeJJREFUSEu1Vj1PwzAQfZcgJDZGpgrKTsTGQopAKgMLGx8qRfyzqkDLbygwtIDESoXEUlGBQGLs3taH3DYmLk7ikpAhkeLzu/O787sjWD6PvS8+frpFzdsZ7dhYXKKkrYkGEmClVWUTUNcvx+6PXZSgDhHAgJCv0MNg9AcCn9tnkRiRC1HR6g4E5thBp2A+gRE836oww0miVK27IHT8k19Yv37YRBzldToHGngaYOlQZuVqragqaQQuy+yg3ZiBiHjG6hMHJIGP2g1rfm0MSQCvW2WigAp5JKuij0Ef7Weg5o2pyTzygBLpR3GelhrTbVVMrDarLFLwEgueuz9nVxglxCaHADvoFkpaeJnW+b9eInnEsAMt8uVWlVPQDpcJncKPxmSqLbLIu/6pwswYfJz7gBoNfL1Z4R7ZS22SOqpLtP/cwIKwq7okK024DqVwEYE4RZ2HPDoMXHpFKOFKiuYv65kL10iwJsqoOC+1rzGc6vCzRhvItuI8DJC+zTGu1nb1NpeFgz4BH5v6iGEeLZoXTBCwk2CGgIs3X1dE1SxM3ObuquxaVaZ+5cNYsTqVf6gxDwfGvA4ImGNdBacNE0Vw7+acX+blpBiYMoZw8G6YsGYGD+Ya+T16ukXd27Ean6X9N3F9zeMGT5CBAAAAAElFTkSuQmCC""")

# set colors
white_color="#FFFFFF" # white
red_color="#BF0000" # red
sensibo_color="#24B999" # sensibo
temp1_color="#FFFFFF"
temp2_color="#FFFFFF"
temp3_color="#FFFFFF"

# variable for hot temp, switches to red font
hot_temp = 74

def main():

	SensiboInfo = http.get(SENSIBO_INFO_API)
	if SensiboInfo.status_code != 200:
		fail("Random number generation failed with status %d", SensiboInfo.status_code)

	location1temp = SensiboInfo.json()["result"][0]["measurements"]["temperature"]
	location2temp = SensiboInfo.json()["result"][1]["measurements"]["temperature"]
	location3temp = SensiboInfo.json()["result"][2]["measurements"]["temperature"]
	location1temp = (location1temp * 9/5) + 32 # Comment out if you want Celsius
	location2temp = (location2temp * 9/5) + 32 # Comment out if you want Celsius
	location3temp = (location3temp * 9/5) + 32 # Comment out if you want Celsius

	if location1temp < hot_temp:
		temp1_color=sensibo_color
	else:
		temp1_color=red_color
	if location2temp < hot_temp:
		temp2_color=sensibo_color
	else:
		temp2_color=red_color
	if location3temp < hot_temp:
		temp3_color=sensibo_color
	else:
		temp3_color=red_color
	
	return render.Root(
        child = render.Column(
          children=[
            render.Row(
                main_align="start", # horizontal alignment
                cross_align="center", # vertical alignment
                expanded=True,
                children = [
                    render.Image(src=SENSIBO_IMG, width=12, height=16),
                    render.Column(
                      main_align="center",
                      cross_align="start",
                      expanded=True,
                      children=[
                        render.Text(" Office  ", color=white_color, font="tom-thumb"),	# Change room names and order as desired
                        render.Text(" Livroom ", color=white_color, font="tom-thumb"),
                        render.Text(" Bedroom ", color=white_color, font="tom-thumb"),
                      ],
                    ),
		    render.Column(
                      main_align="center",
                      cross_align="start",
                      expanded=True,
                      children=[
			render.Text(str(location1temp), color=temp1_color, font="tom-thumb"),
                        render.Text(str(location2temp), color=temp2_color, font="tom-thumb"),
                        render.Text(str(location3temp), color=temp3_color, font="tom-thumb"),
                      ],
                    ),

                ],
            ),
          ],
        ),
    )

