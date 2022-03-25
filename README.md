# Screen Space Effects
Some screen space image effects implemented in Unity3D.  
Some of the effects are demonstrated on a still from Big Buck Bunny, (c) copyright 2008, Blender Foundation / www.bigbuckbunny.org.


**Currently Implemented:**
- Edge detection shader
  - Supports 3 sampling kernels (Sobel, Scharr, Prewitt).
  - Either display the gradients or add or subtract those from the input image.
- Pixel based cel shading effect by limiting the number of available colors.
- Multi-pass Gaussian blur, support for varying radius and standard deviation.
- Bloom, using the Gaussian blur to create bleed-over from bright parts of the image.


# Screenshots
**Display of the gradients as found by the Sobel filter**  
<a href="https://github.com/akoreman/Screen-Space-Effects"><img src="https://raw.github.com/akoreman/screen-space-effects/main/images/RawSobel.png" width="400"></a>  

**Using the Sobel filter to create a black outline effect**  
<a href="https://github.com/akoreman/Screen-Space-Effects"><img src="https://raw.github.com/akoreman/screen-space-effects/main/images/SubtractSobel.png" width="400"></a>  

**Using the Sobel filter to create a neon overlay effect**  
<a href="https://github.com/akoreman/Screen-Space-Effects"><img src="https://raw.github.com/akoreman/screen-space-effects/main/images/AddSobel.png" width="400"></a>  

**Pixel based cel shading effect**  
<a href="https://github.com/akoreman/Screen-Space-Effects"><img src="https://raw.github.com/akoreman/screen-space-effects/main/images/PixelCel.png" width="400"></a>  

**Gaussian blur**  
<a href="https://github.com/akoreman/Screen-Space-Effects"><img src="https://raw.github.com/akoreman/screen-space-effects/main/images/Gaussian.png" width="400"></a>  
