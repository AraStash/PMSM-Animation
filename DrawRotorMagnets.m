function DrawRotorMagnets(ax, nMagnets, rArc, phi)
%DRAWROTORMAGNETS Draw the rotor of radius r with nMagnets permanent magnet
%rotated on phi

% nominal arc
arcHeight = 3;
deltaMagnetAngle=2*pi/nMagnets; % radians per magnet
% the arc pattern is 0.25 - 1 - 0.25. Thus the arc itself is the total
% length divided by 1.5
arcLength=deltaMagnetAngle/1.5;

% number of segments per arc
nArcSegments = ceil(arcLength/(5/180*pi)); % approx 10 degrees per segment
dArcPhi = arcLength/nArcSegments;

polarity = 1; %first one is north

for iMagnet=1:nMagnets
    angleMagnet=pi/2-phi-(iMagnet-1)*deltaMagnetAngle;
    
    DrawOneMagnet(angleMagnet, polarity);
    
    % switch polarity for the next magnet
    if polarity
       polarity=0;
    else
        polarity=1;
    end
end
    

    function DrawOneMagnet(phi, isNorth)
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
            
            if isNorth % N
                color=[0 0 1];
            else
                color=[1 0 0]; %S
            end
            
            %plot the arc
            patch(ax,arcPoint(:,1),arcPoint(:,2),color,'EdgeColor','none'); % no edges
        end        
    end
end

