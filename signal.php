<?php
$subscriber = null;

class Signal {
    private array $subscribers = [];
    private mixed $state;

    public function __construct($value) {
        $this->state = $value;
    }

    public function __get($name) {
        global $subscriber;
        if ($name === 'value') {
            if ($subscriber !== null) {
                $this->subscribers[] = $subscriber;
            }
            return $this->state;
        }
        return $this->$name;
    }

    public function __set($name, $value) {
        if ($name === 'value') {
            $this->state = $value;
            foreach ($this->subscribers as $sub) {
                $sub();
            }
        }else{
            $this->$name = $value;
        }
    }

    public function effect(callable $callback) :Closure {
        global $subscriber;
        $subscriber = $callback;
        $callback();
        $subscriber = null;

        return function() use ($callback) {
            $key = array_search($callback, $this->subscribers);
            if ($key !== false) {
                unset($this->subscribers[$key]);
            }
        };
    }
}


function signal($value)
{
    return new Signal($value);
}

// Example usage:
$signal = signal(10);

$unsubscribe = $signal->effect(function() use ($signal) {
    echo "Signal value: " . $signal->value . "\n";
});

$signal->value = 20;


$signal->value = 25 ;

$unsubscribe(); // Unsubscribe the callback

$signal->value = 30 ;
