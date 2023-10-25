filename=curved-wall-inlet

#remove generated files
clean:
	rm -r flow grid hist loads plot solid config log.txt

prep-gas:
	prep-gas ideal-air.lua ideal-air.gas

prep:
	e4shared --prep --job=${filename}

run:
	e4shared --job=${filename} --run

post:
	e4shared --job=${filename} --post --vtk-xml --tindx-plot=all --add-vars="mach,total-p"

post-plot:
	e4shared --job=${filename} --post --tindx-plot=last --slice-list="1,0,:,0" --output-file="throat-wall-ss.dat" --add-vars="mach,total-p"

post-plot-inlet-tot-pressure:
	e4shared --job=${filename} --post --tindx-plot=last --slice-list="0,0,:,0" --output-file="inlet-freestream-ss.dat" --add-vars="mach,total-p"
