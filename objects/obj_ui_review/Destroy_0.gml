// destruir bowls UI
for (var i = 0; i < array_length(bowls); i++) {

    if (instance_exists(bowls[i])) {
        instance_destroy(bowls[i]);
    }

}