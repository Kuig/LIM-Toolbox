
% Get random sample image and theoretical LSF
[img,lsf] = getSampleImage(80,80,5);

% Calculate LSF with canonical method
[A,w] = getLSFparam(8,28);
canonical = LSF(img,A,w);

% Calculate LSF with NLV-Convolution method
h = getIR(6,1,1,'gauss','out',0,0.02);
nlvc = LSF(img,'NLVConv',h);

% Calculate proper Radon transform
[r,rh] = radon(img,180*(-A/pi)+90);

% Calculate Radon approximation from LSF
[ra,rha] = lsf2radon(img,nlvc,[A;pi/2]);

% Plot 'em all!
subplot(3,2,1)
    imagesc(img);
    axis xy, colormap(gray);
    title('Input Image');

subplot(3,2,2)
    plotLSF(lsf,img);
    title('Theoretical LSF');
    
subplot(3,2,3)
    plotLSF(canonical,img);
    title('Canonical LSF');
    
subplot(3,2,4)
    plotLSF(nlvc,img);
    title('NLV-Conv LSF');
    
subplot(3,2,5)
    imagesc(A,rh,r);
    axis xy,  grid on, colormap(bone);
    title('Radon transform');
    
subplot(3,2,6)
    imagesc(A,rha(1:end),ra(:,1:end));
    axis xy, grid on, colormap(bone);
    title('Radon approximation');