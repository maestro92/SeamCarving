function new_cost = object_removal_and_protection_set_cost_map(cost, protection_mask, removal_mask)
    
% set the protection_mask area to infinity, so it's more costly
% set the removal_mask area to zero, so its less costly
    new_cost = cost;

    new_cost(protection_mask) = Inf;
    new_cost(removal_mask) = 0;

end