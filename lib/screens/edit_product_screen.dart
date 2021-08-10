import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    "imageUrl": '',
  };

  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(() {
      _updateImageUrl();
    });
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // if ((!_imageUrlFocusNode.text.startsWith('https') &&
      //         !!_imageUrlFocusNode.text.startsWith('http')) ||
      //     (!_imageUrlFocusNode.text.endsWith('.png') &&
      //         !_imageUrlFocusNode.text.endsWith('.jpg') &&
      //         !_imageUrlFocusNode.text.endsWith('.jpeg'))) {
      //   return;
      // }

      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      var _editedProduct = Provider.of<Products>(context).findById(productId);
      if (productId == null) {
        _initValues = {
          'title': _editedProduct.title!,
          'description': _editedProduct.description!,
          'price': _editedProduct.price! as String,
          'imageUrl': '',
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    if (_editProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updatProduct(_editProduct.id!, _editProduct as String);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    }
    Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
          key: _form,
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(16.0)),
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide a value";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: value,
                    description: _editProduct.description,
                    price: _editProduct.price,
                    imageUrl: _editProduct.imageUrl,
                    id: _editProduct.id,
                    isFavorite: _editProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter a number greater than zero ";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite,
                      title: _editProduct.title,
                      description: _editProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editProduct.imageUrl);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the description";
                  }
                  if (value.length < 10) {
                    return "Please enter at-least greate the 10 characters";
                  }
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite,
                      title: _editProduct.title,
                      description: value,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "ImageUrl"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a Image URL";
                        }
                        if (!value.startsWith('https') &&
                            !value.startsWith('http')) {
                          return "Please enter a valid URl";
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return "Please enter a valid Image Url";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            title: value,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value);
                      },
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
