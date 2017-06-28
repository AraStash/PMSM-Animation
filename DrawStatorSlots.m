function DrawStatorSlots(ax, nSlots, r, slotIntens, nameWind)
%DRAWSTATORSlotS Draw the elctroSlots of the stator

% input:
% ax - axes
% nSlots - number f Slots
% r - radius of the Slots' centers
% values - current values for the Slots

SOLID_ARC=0; % 1 for solid arc and 0 for a cloud of dashed lines
SOLID_MAGNET=0;% 1 for solid magnet 0 for gradient

% set size    
switch nSlots
    case 3
        width=6;
    case 6
        width=4;
    case 9
        width=3;
    otherwise
        width=2;
end
height=6;

arcOffset=1;
arcHeight=1.4;

colorMap=get(get(ax,'Parent'),'Colormap');
nHalfColorMap=fix((length(colorMap)-1)/2);

% basic figure
% top-left
tl=[r+height/2;width/2];
% top-right
tr=[r+height/2;-width/2];
% bottom-left
bl=[r-height/2;width/2];
% bottom-right
br=[r-height/2;-width/2];
% text place
textPosition=[r-height/2-1.5;0];

% basic arc
rArc = r+ height/2 + arcOffset;
arcLength = 2*pi/nSlots;
nArcSegments = ceil(arcLength/(10/180*pi)); % approx 10 degrees per segment
dArcPhi = arcLength/nArcSegments;

% basic cloud
nCloudLines = ceil(arcLength/(3/180*pi)); % approx each 3 degrees
dCloudPhi = arcLength/nCloudLines;

% angle between two slots
deltaAngle=2*pi/nSlots;

% Draw all the slots
for iSlot=1:nSlots
    angleSlot=pi/2-(iSlot-1)*deltaAngle;
    DrawOneSlot(angleSlot, slotIntens(iSlot), nameWind(iSlot));
end


% this function draws one Slot with given phi and intens
    function DrawOneSlot(phi, intens, symbol)
        % rotation map
        rotationMat=[cos(phi) -sin(phi);...
             sin(phi) cos(phi)];
         
        % this Slot 
        slotTL=rotationMat*tl;         
        slotTR=rotationMat*tr;
        slotBL=rotationMat*bl;
        slotBR=rotationMat*br;
        textPos=rotationMat*textPosition;
        
        slotPoint=[slotBL slotBR slotTR slotTL]';
        
        % colors
        collorShift=round(intens*nHalfColorMap);
        bottomColor=nHalfColorMap+1-collorShift;
        topColor=nHalfColorMap+1+collorShift;
        
        %plot the Slot
        if SOLID_MAGNET %only topColor used
            patch(ax,slotPoint(:,1),slotPoint(:,2),[topColor topColor topColor topColor]);
        else
            patch(ax,slotPoint(:,1),slotPoint(:,2),[bottomColor bottomColor topColor topColor]);
        end

        
        % plot the text
        if symbol=='A' || symbol=='a'
            textColor='r';
        elseif symbol=='B' || symbol=='b'
            textColor='b';
        elseif symbol=='C' || symbol=='c'
            textColor='g';
        else 
            textColor='k';
        end
            
        text(ax,textPos(1), textPos(2), symbol,'FontSize',12,'Color',textColor);
        
        % the arc or the cloud
        if (SOLID_ARC) % the arc
            for iSegment=1:nArcSegments
                % angles of this segment
                leftAngle=phi+arcLength/2 - (iSegment-1)*dArcPhi;
                rightAngle=phi+arcLength/2 - (iSegment)*dArcPhi;

                % compute the arc's corners
                arcTL=(rArc+arcHeight/2)*[cos(leftAngle);sin(leftAngle)];
                arcTR=(rArc+arcHeight/2)*[cos(rightAngle);sin(rightAngle)];

                arcBL=(rArc-arcHeight/2)*[cos(leftAngle);sin(leftAngle)];
                arcBR=(rArc-arcHeight/2)*[cos(rightAngle);sin(rightAngle)];

                arcPoint=[arcBL arcBR arcTR arcTL]';

                %plot the arc
                patch(ax,arcPoint(:,1),arcPoint(:,2),topColor,'EdgeColor','none');        
            end
            
        else % ~SOLID_ARK, draw the cloud
            for iLine=1:nCloudLines
                angleLine=phi+arcLength/2 - (iLine-1)*dCloudPhi;
                valX=cos(angleLine)*(rArc+[-arcHeight/2; arcHeight/2]);
                valY=sin(angleLine)*(rArc+[-arcHeight/2;  arcHeight/2]);
                
                plot(ax,valX, valY,'LineStyle','--','Color',colorMap(topColor,:));
            end
        end
       
    end
end

