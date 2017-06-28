function MakeDriveAnimation(fileName, FPS, duration, nSlots, nMagnets, voltRotationFreq)
%MAKEDRIVEANIMATION make animation of the given PMSM

% stator
voltOffset=pi/2; %to make phase A=1 at t=0

% drawing params 
rStator=10;
rRotor=18;
nColorMap=255;

% PRELIMINARIES
%time 
dt=1/FPS;
time=0:dt:duration-dt;

%absolute value of rototr rotation frequency 
absRotorRotationFreq=voltRotationFreq/(nMagnets/2); %Hz

% types of windings
switch nSlots
    case 3
        nameWind='ABC';
        rotorOffset=0;
        switch nMagnets
            case 2
                rotorRotationFreq=-absRotorRotationFreq;
            case 4
                rotorRotationFreq=absRotorRotationFreq;
            otherwise
                error('Unknown wind-mag combination.');
        end
    case 6
        nameWind='ABCABC';
        rotorOffset=0;
        switch nMagnets
            case 4
                rotorRotationFreq=-absRotorRotationFreq;
            case 8
                rotorRotationFreq=absRotorRotationFreq;
            otherwise
                error('Unknown wind-mag combination.');
        end        
    case 9
        switch nMagnets
            case 6
                nameWind='ABCABCABC';
                rotorRotationFreq=-absRotorRotationFreq;
                rotorOffset=0;
            case 8
                nameWind='AaABbBCcC';    
                rotorOffset=2*pi*(1/nSlots - 1/nMagnets);                        
                rotorRotationFreq=-absRotorRotationFreq;
            case 10
                nameWind='AaABbBCcC';
                rotorOffset=2*pi*(1/nSlots - 1/nMagnets);                        
                rotorRotationFreq=absRotorRotationFreq;
            case 12
                nameWind='ABCABCABC';
                rotorRotationFreq=absRotorRotationFreq;
                rotorOffset=0;
            otherwise
                error('Unknown wind-mag combination.');
        end
    case 12 
        nameWind='AabBCcaABbcC';
        rotorOffset=2*pi*(1/nSlots/2-1/nMagnets/2); 
        switch nMagnets
            case 10
                rotorRotationFreq=-absRotorRotationFreq;
            case 14
                rotorRotationFreq=absRotorRotationFreq;
            otherwise
                error('Unknown wind-mag combination.');
        end        
    otherwise
        error('I do not know this winding.');
end

% voltages
voltAAll=sin(voltOffset + time*voltRotationFreq*2*pi);
voltBAll=sin(voltOffset + time*voltRotationFreq*2*pi + 2*pi/3);
voltCAll=sin(voltOffset + time*voltRotationFreq*2*pi + 4*pi/3);


% PLOTS
% create figure and axes
% figure
mainFigure = figure('Color',[1 1 1], 'Colormap',getRBColormap(nColorMap),'Position',[300 300 1000 500]);
% axes 1 - motor
axDrive = axes('Parent',mainFigure,...
    'Position',[0.03 0.05 0.45 0.9]);
box(axDrive,'on');
set(axDrive,'XAxisLocation','bottom','XGrid','off','XTick',zeros(1,0),'XTickLabel',{},'XLim',[-20 20]);
set(axDrive,'YAxisLocation','left','YGrid','off','YTick',zeros(1,0),'YTickLabel',{},'YLim',[-20 20]);
set(axDrive,'PlotBoxAspectRatio',[1 1 1]);
set(axDrive,'NextPlot','add');

% axes 2 - voltages
axVolts = axes('Parent',mainFigure,...
    'Position',[0.55 0.25 0.4 0.5]);
box(axVolts,'on');
set(axVolts,'XAxisLocation','bottom','XGrid','on','XLim',[0 time(end)+dt]);
set(axVolts,'YAxisLocation','origin','YGrid','on','YLim',[-1.1 1.1]);
set(axVolts,'NextPlot','add');

%plot voltages
plot(axVolts, time, voltAAll, 'Color','r','LineWidth',2);
plot(axVolts, time, voltBAll, 'Color','b','LineWidth',2);
plot(axVolts, time, voltCAll, 'Color','g','LineWidth',2);
% plot timeline
plTimeLine = plot(axVolts, [0 0], [-1.1 1.1], 'Color','k','LineWidth',1, 'LineStyle','--');

% for frame grabbing
M=[];
PIC=[];

% Main loop
for iTime=1:length(time)
   
    %current rotor angle
    rotorRotation=rotorOffset+time(iTime)*rotorRotationFreq*2*pi;

    % voltages in phases
    voltA=voltAAll(iTime);
    voltB=voltBAll(iTime);
    voltC=voltCAll(iTime);

    % decode windings
    voltSlot=zeros(nSlots,1);
    for iSlot=1:nSlots
        switch nameWind(iSlot)
            case 'A'
                voltSlot(iSlot)=voltA;
            case 'B'
                voltSlot(iSlot)=voltB;
            case 'C'
                voltSlot(iSlot)=voltC;
            case 'a'
                voltSlot(iSlot)=-voltA;
            case 'b'
                voltSlot(iSlot)=-voltB;
            case 'c'
                voltSlot(iSlot)=-voltC;
            otherwise
                error('Unknown winding symbol.');
        end
    end
    
    % clear previouse drawings of the motor
    cla(axDrive);
    
    % draw the stator
    DrawStatorSlots(axDrive, nSlots, rStator, voltSlot, nameWind);
    
    % draw the magnets
    DrawRotorMagnets(axDrive, nMagnets, rRotor, rotorRotation);
    
    %update the timeline 
    set(plTimeLine,'XData',[time(iTime) time(iTime)]);
    
    % grab the frame
    F=getframe(mainFigure);
    if isempty(M)
        [X,M]=rgb2ind(F.cdata,200);
    else
        X=rgb2ind(F.cdata,M);
    end
    if isempty(PIC)
        PIC=zeros(size(X,1), size(X,2), 1, length(time));
    end
    PIC(:,:,1,iTime)=X;  %#ok<AGROW>
end

imwrite(PIC+1,M,fileName,'gif','DelayTime',dt,'LoopCount',100);

close(mainFigure);

end

