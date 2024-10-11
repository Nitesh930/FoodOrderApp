const mongoose = require('mongoose')

mongoose.connect('mongodb://localhost:27017/foodOrder')

const user= mongoose.Schema({
    ItemName:String,
    price: Number,
})

module.exports= mongoose.model('users',user)
