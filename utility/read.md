**This Folder including the useful function for diffraction imaging simulation**

- Fraunhofer_Prop----calculate fraunhofer diffraction
- Fresnel_Prop----calculate Fresnel diffraction
- Sommerfeld_Prop----calculate Sommerfeld diffraction (including AS)
- fft_DOE----used for 2D FFT calculation in diffraction
- ifft_DOE----used for 2D iFFT calculation in diffraction
- fft_point---used for fft_slice function, only one point fft
- fft_slice---direct calculate fft slice of a 4D data,used in wigner function
- upsample---upsample a image
- mutial_cal---used for mutual function calculation of a field
- mydisplay_slice---display fft slice of a 4D data
- mydiplay_WA---display wigner or ambigious function of a field
- ItohPhaseUnwrap---use Itoh algrithm to unwrap a phase
- SnpPhaseUnwrap---use  Miguel Arevallio Herraez's method to unwrap a phase
- getphase---get a wrap phase of a field,the range is [0,2pi], different to the matlab default function [-pi,pi]
