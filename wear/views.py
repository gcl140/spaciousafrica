from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from .models import Product, ProductCategory, Order


def product_list(request):
    category_slug = request.GET.get('category', '')
    products = Product.objects.all()
    categories = ProductCategory.objects.all()
    active_category = None
    if category_slug:
        active_category = ProductCategory.objects.filter(slug=category_slug).first()
        if active_category:
            products = products.filter(category=active_category)
    return render(request, 'wear/product_list.html', {
        'products': products,
        'categories': categories,
        'active_category': active_category,
    })


def product_detail(request, pk):
    product = get_object_or_404(Product, pk=pk)
    if request.method == 'POST' and product.is_in_stock():
        customer_name = request.POST.get('customer_name', '').strip()
        customer_email = request.POST.get('customer_email', '').strip()
        customer_phone = request.POST.get('customer_phone', '').strip()
        size = request.POST.get('size', '').strip()
        quantity = int(request.POST.get('quantity', 1))
        shipping_address = request.POST.get('shipping_address', '').strip()
        if customer_name and customer_email and shipping_address:
            total = product.price * quantity
            Order.objects.create(
                product=product,
                customer_name=customer_name,
                customer_email=customer_email,
                customer_phone=customer_phone,
                size=size,
                quantity=quantity,
                shipping_address=shipping_address,
                total_price=total,
            )
            messages.success(request, f'Order placed for {product.name}! We will contact you shortly.')
            return redirect('product_detail', pk=pk)
        else:
            messages.error(request, 'Please fill in all required fields.')
    related = Product.objects.exclude(pk=pk).filter(category=product.category)[:3]
    return render(request, 'wear/product_detail.html', {'product': product, 'related': related})
