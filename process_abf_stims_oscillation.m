function process_abf_stims_oscillation(tracein,stim1,stim2,fs)


%artifact removal
tracein(tracein>-40)=-40;
tracein(tracein<-85)=-85;
%tracein = resample(tracein,1, Fsorig/Fsnew);
%tracein = smooth(tracein,500);


%t=0:(1/Fsorig):(length(tracein)*(1/Fsorig)-(1/Fsorig));
%tracein = resample(tracein,Fsnew,Fsorig);

out.protophase = co_hilbproto(tracein,0,0,0,0);
[out.phi out.arg out.sig] = co_fbtrT(out.protophase);

xvec=0:(1/fs):(length(tracein)*(1/fs))-(1/fs);


figure; 
fig_size(gcf,800,200);
subplot(9,1,1:7);

[~,hLine1,hLine2] = plotyy(xvec,normdat(out.phi),xvec, tracein); 

set(hLine1,'color', [0 0 0]);
set(hLine2,'color', [0.8 0.5 0.3]);

box off;
set(gca,'TickDir','out');
 set(gca,'xticklabel',[]);
% subplot(9,1,8:9);
% hold on; 
% plot(xvec,normdat(stim2),'b');
% plot(xvec,normdat(stim1),'r');
% box off; set(gca,'yticklabel',[]);
% set(gca,'TickDir','out');
% set(gcf,'Color','w');
% subplot(9,1,1:7);
% assignin('base','outphi',out.phi);
% assignin('base','tracein',tracein);
% 

%figure; hist(abs(Fsorig/(2*pi)*diff(unwrap(out.phi))),1000);