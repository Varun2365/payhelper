

function sumOfEvenNumbers(list){
    var sum = 0;
    for(var i = 0; i<list.length; i++){
        if(list[i] % 2 == 0){
            sum+= list[i]
        }
    }
    console.log(sum)
}

var myList = [31,42,663,44,75,62]
sumOfEvenNumbers(myList)
