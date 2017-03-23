% function made to plot the magnitudes from a PHASES structure
% 
% Input:
%     PHASES: PHASES structure

function plotmag_PHASES(PHASES)

%%% Retrieve indices of non empty mags and get PHASES

%ind_mag=find(~cellfun(@isempty,{PHASES.MAG}));
PHASES_MAG=PHASES(~cellfun(@isempty,{PHASES.MAG}));

distance=[PHASES_MAG.DIS];
station={PHASES_MAG.STATION};
amplitude=[PHASES_MAG.AMP];
mag=[PHASES_MAG.MAG];

PHASES_MAG_SELECT=PHASES(~cellfun(@isempty,{PHASES.MAG}) & cellfun(@(x) x==1,{PHASES.WRITE_FLAG}));

distance_sel=[PHASES_MAG_SELECT.DIS];
amplitude_sel=[PHASES_MAG_SELECT.AMP];
mag_sel=[PHASES_MAG_SELECT.MAG];

%%%%%%%%%%%%%%%%%%%
%%% Start plot %%%%
%%%%%%%%%%%%%%%%%%%

%%%% First figure

figure
hold on

[AX,h1,h2]=plotyy(distance,amplitude,distance,mag);

set(h1,'linestyle','-.',...
    'marker','s','markeredgecolor','k','markerfacecolor','w',...
    'markersize',10)

set(h2,'linestyle','--',...
    'marker','s','markeredgecolor','k','markerfacecolor','w',...
    'markersize',10)


set(AX(2),'Ylim',[0 6])
set(AX(2),'Ytick',(0:0.5:6))

%%%%

if ~isempty(distance_sel)
    [AY,h3,h4]=plotyy(distance_sel,amplitude_sel,distance_sel,mag_sel);

    set(h3,'linestyle','none',...
        'marker','s','markeredgecolor','k','markerfacecolor','r',...
        'markersize',10)

    set(h4,'linestyle','none',...
        'marker','s','markeredgecolor','k','markerfacecolor','r',...
        'markersize',10)
    
    set(AY(2),'Ylim',[0 6])
    set(AY(2),'Ytick',(0:0.5:6))
end

text(distance,amplitude+10,station,'HorizontalAlignment','center',...
    'verticalAlignment','bottom')



%%% Labels

set(get(AX(2),'ylabel'),'string','Ml')
set(get(AX(1),'ylabel'),'string','Amplitude (nm)')
xlabel('Distance (km)')

%%%% Second figure
figure
hold on
mag_edges=0:0.5:6;

n=histc(mag,mag_edges);

b1=bar(mag_edges,n,'histc');

set(b1,'facecolor','k','edgecolor','w')

xlabel('Ml');
ylabel('# events');
title(sprintf('Mean = %5.2f, Median = %5.2f and Standard = %5.2f',mean(mag),median(mag),std(mag)));

if ~isempty(mag_sel)
    n_sel=histc(mag_sel,mag_edges);
    b2=bar(mag_edges,n_sel,'histc');
    set(b2,'facecolor','r','edgecolor','w')
    set(gca, 'Layer', 'top')
    title(sprintf('Mean = %5.2f, Median = %5.2f and Standard = %5.2f\n Mean = %5.2f, Median = %5.2f and Standard = %5.2f',...
        mean(mag),median(mag),std(mag),mean(mag_sel),median(mag_sel),std(mag_sel)));

end
hold off

end








