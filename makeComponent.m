function component = makeComponent(compName, startNode, endNode, type)
% MAKECOMPONENT is used to input each component. It returns the component
% array useful to create the netlist. This follows the LTSPice netlist
% format
component.name = compName;
component.startNode = startNode;
component.endNode = endNode;
component.type = type;
end
