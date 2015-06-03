# This script loads a pair of images (nominally PIV interrogation regions),
# then calculates and plots their phase correlation using forward and
# inverse Fourier transforms. The main point of this script is to show
# how to (1) load dependencies and invoke namespaces, (2) load and manipulate images,
# (3) plan and execute forward and inverse Fourier transforms,
# and (4) plot results.

# Install dependencies
Pkg.add("Images")
Pkg.add("TestImages")
# Pkg.add("PyPlot")

# Invoke namespaces
using Base
using Images
using TestImages
# using PyPlot
using FixedPointNumbers

# Load the images
# The extra business here converts the loaded image from a built-in image-datatype
# to floats which can be multiplied by the Gaussian window.
img_01 = float(convert(Array, Images.imread("/Users/matthewgiarra/Desktop/image_01.tif")));
img_02 = float(convert(Array, Images.imread("/Users/matthewgiarra/Desktop/image_02.tif")));

# Determine the sizes of the images.
(height, width) = size(img_01)

# Form coordinates for plotting.
# I couldn't find an equivalent to "meshgrid"
# or "ndgrid" in Julia.
y = repmat(1:height, 1, width);
x = repmat((1:width)', height, 1);

# Centroid location
xc = width / 2;
yc = height / 2;

# Window standard deviation
# This is arbitrary and "looks ok" without
# bothering to calculate the effective window resolution here.
window_std_dev = 25;

# Create a Gaussian window
gaussian_window = (exp(-(x - xc).^2/window_std_dev^2) .* exp(-(y - yc).^2 / window_std_dev^2));

# Plan an FFT
# Alternatively we could use plan_rfft in anticipation
# that the input data are real, but then the size
# comes out as [height/2, width],
# which is not bad, but I am not doing it now.
p = plan_fft(img_01, [1, 2], FFTW.MEASURE);

using cross_correlation

spectral_corr_complex = cross_correlation.cross_correlation(img_01, img_02, p);

# Execute the FFT plan on the two images.
f1 = p(img_01 .* gaussian_window)
f2 = p(img_02 .* gaussian_window)

# Cross correlation via conjugate multiplication
# of the images' Fourier transforms.
c1 = f1 .* conj(f2);

# Calculate the magnitude of the correlation.
mag = abs(c1);

# Set zeros to one. I'm not sure yet how
# to do element-wise comparisons, e.g., mag[k == 0] = 1
for k = 1 : length(mag)
  if mag[k] == 0
    mag[k] = 1;
  end
end

# Calculate the phase of the complex cross correlation
c1_phase = c1 ./ mag;

# Calculate the angle of the phase
c1_angle = fftshift(angle(c1_phase));

# Plan the inverse Fourier transform
p_inv = plan_ifft(c1, [1, 2], FFTW.MEASURE);

# Take the inverse transform
if1 = ifftshift(abs(real(p_inv(c1))));

# Plot the spatial correlation plane
plot_surface(x, y, if1./ maximum(if1), cmap = "coolwarm", rstride = 1, cstride = 1)
xlabel("Column")
ylabel("Row")
zlabel("Normalized correlation coefficient")
title("Phase correlation, 64x64-pixel PIV region")
