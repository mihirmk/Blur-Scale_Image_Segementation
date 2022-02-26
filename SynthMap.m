function [Synth,Blur_scales]=SynthMap(n,m,sq, Bmax, Bmin)
Synth = zeros(n,m);
dn=round(n/(2.5*sq));
dm=round(m/(2.5*sq));
dB=(Bmax-Bmin)/(sq-1);

for i = 1:sq
    Synth(dn*i:end-dn*i,dm*i)=Bmax-(i-1)*dB;
    Synth(dn*i:end-dn*i,end-dm*i)=Bmax-(i-1)*dB;
    Synth(dn*i,dm*i:end-dm*i)=Bmax-(i-1)*dB;
    Synth(end-dn*i,dm*i:end-dm*i)=Bmax-(i-1)*dB;
    Blur_scales(i) = Bmax-(i-1)*dB;
end
end