using Images
using FixedPointNumbers
include("cross_correlation.jl")
include("gaussianWindowFilter.jl")
include("meshgrid.jl")
include("gridImage.jl")
include("extractSubRegions.jl")
include("correlate_regions.jl")

function xcorr_script()


	# Size of the interrogation regions
	region_height = 64;
	region_width  = 64;

	# Some constants
	grid_spacing = [16, 16];
	grid_buffer_y = [32, 32];
	grid_buffer_x = [32, 32];
	
	# Gaussian window standard deviations
	gaussian_window_std_x = 25;
	gaussian_window_std_y = 25;

	# Load the images
	# The extra business here converts the loaded image from a built-in image-datatype
	# to floats which can be multiplied by the Gaussian window.
	img_01 = float32(convert(Array, Images.imread("/Users/matthewgiarra/Desktop/image_01.tif")));
	img_02 = float32(convert(Array, Images.imread("/Users/matthewgiarra/Desktop/image_02.tif")));

	# Determine the sizes of the images.
	(image_height, image_width) = size(img_01)

	# Grid the image
	(gy, gx) = gridImage([image_height, image_width], 
		grid_spacing, grid_buffer_y, grid_buffer_x); 
		
	# Number of regions
	num_regions = length(gy);

	# Create a Gaussian window
	gaussian_window = float32(gaussianWindowFilter([region_height, region_width],
	[gaussian_window_std_y, gaussian_window_std_x]));
			
	# Create a dummy region for planning the FFTs.
	dummy_region = float32(rand(region_height, region_width));
	
	# Plan the FFT
	ft_plan = plan_fft(dummy_region, [1, 2], FFTW.MEASURE);
	
	# Extract all the regions from the first image and multiply them by the apodizaiton window.
	region_matrix_01 = extractSubRegions(img_01, [region_height, region_width], gy, gx);
		
	# Extract all the regions from the second image and multiply them by the apodizaiton window. 
	region_matrix_02 = extractSubRegions(img_01, [region_height, region_width], gy, gx);
	
	# Apodize the regions
	for k = 1 : num_regions
		region_matrix_01[:, :, k] = region_matrix_01[:, :, k] .* gaussian_window;
		region_matrix_02[:, :, k] = region_matrix_02[:, :, k] .* gaussian_window;
	end
		
	# Perform the correlations	
	# Actually, 
	@time correlate_regions(region_matrix_01, region_matrix_02, ft_plan);
	

	
end