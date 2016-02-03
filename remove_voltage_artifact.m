function traces=remove_voltage_artifact(traces, threshold)
threshold=1;
sz=size(traces);

if(sz(1)>sz(2))
    
    traces=traces';
    sz=size(traces);
    
end


for i=1:sz(1)
    
   diff_tr = abs(diff(traces(i,:))); 
%    figure;
%    plot(normdat(traces(i,:)));
%    hold on;
  
   [pks, locs] = findpeaks(diff_tr,'MinPeakHeight',threshold, 'MinPeakDistance',100); 
   for k=length(locs)
       if(locs(k)-500>0)
           traces(i,locs(k)-500:locs(k)+500)=NaN;
       end
   end
%    plot(normdat(traces(i,:)),'g');
   traces(i,:)=naninterp(traces(i,:));
   
%    disp('size peaks');
%    size(pks)
%    locs
%    plot(normdat(diff_tr),'r');
%    hold off;
%    pause;
   clear diff_tr;
end