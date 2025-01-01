classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        FrequencyEditField       matlab.ui.control.NumericEditField
        FrequencyEditFieldLabel  matlab.ui.control.Label
        TabGroup                 matlab.ui.container.TabGroup
        Tab                      matlab.ui.container.Tab
        UIAxes                   matlab.ui.control.UIAxes
        Tab2                     matlab.ui.container.Tab
        UIAxes_2                 matlab.ui.control.UIAxes
        Tab3                     matlab.ui.container.Tab
        UIAxes_3                 matlab.ui.control.UIAxes
        Tab4                     matlab.ui.container.Tab
        UIAxes_4                 matlab.ui.control.UIAxes
        Tab5                     matlab.ui.container.Tab
        UIAxes_5                 matlab.ui.control.UIAxes
        PlotButton               matlab.ui.control.Button  % Added PlotButton property
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [2 1 639 316];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Tab';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [99 20 441 255];

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Tab2';

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.Tab2);
            title(app.UIAxes_2, 'Title')
            xlabel(app.UIAxes_2, 'X')
            ylabel(app.UIAxes_2, 'Y')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.Position = [99 20 441 255];

            % Create Tab3
            app.Tab3 = uitab(app.TabGroup);
            app.Tab3.Title = 'Tab3';

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.Tab3);
            title(app.UIAxes_3, 'Title')
            xlabel(app.UIAxes_3, 'X')
            ylabel(app.UIAxes_3, 'Y')
            zlabel(app.UIAxes_3, 'Z')
            app.UIAxes_3.Position = [99 20 441 255];

            % Create Tab4
            app.Tab4 = uitab(app.TabGroup);
            app.Tab4.Title = 'Tab4';

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.Tab4);
            title(app.UIAxes_4, 'Title')
            xlabel(app.UIAxes_4, 'X')
            ylabel(app.UIAxes_4, 'Y')
            zlabel(app.UIAxes_4, 'Z')
            app.UIAxes_4.Position = [99 20 441 255];

            % Create Tab5
            app.Tab5 = uitab(app.TabGroup);
            app.Tab5.Title = 'Tab5';

            % Create UIAxes_5
            app.UIAxes_5 = uiaxes(app.Tab5);
            title(app.UIAxes_5, 'Title')
            xlabel(app.UIAxes_5, 'X')
            ylabel(app.UIAxes_5, 'Y')
            zlabel(app.UIAxes_5, 'Z')
            app.UIAxes_5.Position = [99 20 441 255];

            % Create FrequencyEditFieldLabel
            app.FrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.FrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.FrequencyEditFieldLabel.Position = [8 442 62 22];
            app.FrequencyEditFieldLabel.Text = 'Frequency';

            % Create FrequencyEditField
            app.FrequencyEditField = uieditfield(app.UIFigure, 'numeric');
            app.FrequencyEditField.Position = [85 442 100 22];

            % Create PlotButton
            app.PlotButton = uibutton(app.UIFigure, 'push');
            app.PlotButton.Position = [200 442 100 22];  % Positioning the button
            app.PlotButton.Text = 'Plot Antenna';  % Button text
            app.PlotButton.ButtonPushedFcn = @(btn, event) PlotAntenna(app);  % Callback to PlotAntenna function

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % Antenna Plot Function
    methods (Access = private)
    function PlotAntenna(app)
        % Get the frequency from the input field
        f = app.FrequencyEditField.Value;

        % Check if frequency is below 1 kHz
        if f < 1e3
            uialert(app.UIFigure, 'Frequency must be greater than 1 kHz.', 'Invalid Frequency', 'Icon', 'error');
            return;  % Exit the function if the frequency is invalid
        end

        % Parameters for planar bowtie antenna design
        m = metal('Steel');
        b = bowtieTriangular('Length', 0.2046 + 0.0108, ...
                              'FlareAngle', 2*atan(0.0511/0.1046)*180/pi, ...
                              'Conductor', m);

        % Show the antenna geometry
        show(b);

        % Radiation Pattern
        figure;
        pattern(b, f);
        title('Radiation Pattern');

        % VSWR
        figure;
        vswr(b, 100e6:1e6:800e6);

        % Return Loss
        figure;
        returnLoss(b, 100e6:1e6:800e6);

        % Azimuth Plane Pattern (Side View)
        figure;
        patternAzimuth(b, f);

        % Elevation Plane Pattern (Front View)
        figure;
        patternElevation(b, f);

        % Impedance
        figure;
        impedance(b, 100e6:1e6:800e6);

        % HPBW for azimuth angle = 0
        figure;
        beamwidth(b, 455e6, 0, 1:1:360, 3);

        % Efficiency
        figure;
        efficiency(b, 100e6:1e6:800e6);

        % S-parameters
        sobj = sparameters(b, 100e6:1e6:800e6);
        figure;
        rfplot(sobj);
    end
end


    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
