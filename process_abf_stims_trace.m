function process_abf_stims_trace(tracein,stim1,stim2,fs)

xvec=0:(1/fs):(length(tracein)*(1/fs))-(1/fs);

size(tracein)
size(xvec)
size(stim1)
size(stim2)

figure; 
fig_size(gcf,800,200);
subplot(9,1,1:7);


plot(xvec,tracein,'Color',[0.8 0.5 0.3], 'LineWidth', 2); 
box off;
set(gca,'TickDir','out');
set(gca,'xticklabel',[]);
subplot(9,1,8:9);
hold on; 
plot(xvec,normdat(stim2),'b');
plot(xvec,normdat(stim1),'r');
box off; set(gca,'yticklabel',[]);
set(gca,'TickDir','out');
set(gcf,'Color','w');
subplot(9,1,1:7);
