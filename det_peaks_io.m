function [p,l] = det_peaks_io(trace,fs)

%trace= trace - mean(trace);

minpk =  mean(trace)+2*(std(trace));

maxpk = -40;

[p,l]=findpeaks(trace,'MinPeakHeight',minpk,'MinPeakDistance', round(fs/12));

idx=find(p>-40);

p(idx)=[];
l(idx)=[];

%figure; hold on;plot(trace); plot(l,p,'ro');
pks_sv = zeros(size(trace));
pks_sv(l)=1;
pkswin=zeros(size(trace));
fsd=fs*30;

%gauss = create_gauss(-60000:60000, 60000) %

% % Construct blurring window.
% windowWidth = int16(10e3);
% halfWidth = windowWidth / 2
% gaussFilter = gausswin(50e3)
% gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.
% 
% 
% out=conv(pks_sv,gaussFilter);

length(pks_sv)
for i=1:length(pks_sv)
  
    if(i-(fsd)<=1)
        %disp('smaller than 1');
        pkswin(i) = sum(pks_sv(1:i+fsd)) / (length(pks_sv(1:i+fsd))/fs);
    elseif(i+(fsd)>=length(pks_sv))
        %disp('bigger than length(pks_sv)');
        pkswin(i) = sum(pks_sv((i-fsd+1):end)) / (length(pks_sv((i-fsd+1):end))/fs);
    elseif(i-(fsd)>1 && i+(fsd)<length(pks_sv))
        
        pkswin(i) =  sum(pks_sv( (i-(fsd)):(i+fsd) ) ) / (length(pks_sv( (i-(fsd)):(i+fsd) ))/fs);

        
    end

end
xvec=0:1/fs:(length(trace)*(1/fs))-(1/fs);
figure; hold on; plot(xvec, pkswin); 
