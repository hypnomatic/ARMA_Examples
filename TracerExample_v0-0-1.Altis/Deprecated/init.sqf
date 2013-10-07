/*
General init for the tracer function
*/
firedBullets = [];

addMissionEventHandler ["Draw3D", { //On every frame...
    {
        for "_i" from 0 to (count _x) - 2 do {
            drawLine3D [_x select _i, _x select (_i + 1), [1,0,0,1]]; //...draw lines connecting the positions on the path that the bullet took...
        };
    } forEach firedBullets; //...for every bullet that has been fired since the last clearing.
}];
player addAction["Clear Lines", {firedBullets=[];}]; //Clears the lines of all bullets no longer in the air

/*
Syntax: 
    [_unit] call hyp_fnc_traceFire;
Params: 
    _unit: Either a vehicle or unit
Return Value:
    Scalar: The ID of the "fired" EventHandler that was added.
*/
hyp_fnc_traceFire = {
    (_this select 0) addEventHandler ["fired", {
        [_this, (position(_this select 6))] spawn {
            private["_params","_initialPos","_bullet","_index","_positions"];
            //Vars and Params
            _params     = _this select 0;
            _initialPos = _this select 1;
            _bullet     = _params select 6;
            _index      = count firedBullets;
            _positions  = [_initialPos];

            //Assemble the array of positions and push it to the global array
            waitUntil {
                if (isNull _bullet) exitWith {true};
                _positions set [count _positions, position _bullet];
                firedBullets set [_index, _positions];
            };
        };
    }]
};  

[soldier1] call hyp_fnc_traceFire;
[tank1] call hyp_fnc_traceFire;

