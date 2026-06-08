// app.js
const API_URL = 'http://localhost/portfolio/warehouse-manager/api/products.php';

// Tablica na dane w pamięci podręcznej przeglądarki
let localProducts = []; 
let currentSort = { field: '', asc: true }; 

document.addEventListener('DOMContentLoaded', () => {
    fetchProducts();
    document.getElementById('productForm').addEventListener('submit', addProduct);
});

// 1. POBIERANIE PRODUKTÓW (GET)
async function fetchProducts() {
    try {
        const response = await fetch(API_URL);
        localProducts = await response.json();
        renderTable(localProducts);
    } catch (error) {
        console.error('Błąd pobierania danych:', error);
    }
}

// 2. RENDEROWANIE W TABELI + DRAG & DROP
function renderTable(products) {
    const tableBody = document.getElementById('productsTableBody');
    tableBody.innerHTML = '';

    if (products.length === 0) {
        tableBody.innerHTML = `<tr><td colspan="6" class="px-6 py-4 text-center text-gray-500">Magazyn jest pusty.</td></tr>`;
        return;
    }

    products.forEach((product, index) => {
        const row = document.createElement('tr');
        row.className = 'hover:bg-gray-50 transition cursor-move select-none';
        row.draggable = true;
        row.dataset.index = index;

        row.innerHTML = `
            <td class="px-4 py-4 font-mono text-sm text-gray-900">${product.sku}</td>
            <td class="px-4 py-4 text-sm font-medium text-gray-800">${product.name}</td>
            <td class="px-4 py-4 text-sm text-gray-500">${product.category}</td>
            <td class="px-4 py-4 text-sm text-gray-900 font-semibold">${parseFloat(product.price).toFixed(2)} PLN</td>
            <td class="px-4 py-4 text-sm">
                <span class="px-2 py-1 rounded text-xs font-bold ${product.stock > 5 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                    ${product.stock} szt.
                </span>
            </td>
            <td class="px-4 py-4 text-sm text-right">
                <button onclick="deleteProduct(${product.id})" class="text-red-600 hover:text-red-900 font-medium cursor-pointer transition">
                    Usuń
                </button>
            </td>
        `;

        row.addEventListener('dragstart', handleDragStart);
        row.addEventListener('dragover', handleDragOver);
        row.addEventListener('drop', handleDrop);

        tableBody.appendChild(row);
    });
}

// 3. WYSYŁANIE PRODUKTU (POST)
async function addProduct(e) {
    e.preventDefault();

    const productData = {
        name: document.getElementById('name').value,
        sku: document.getElementById('sku').value,
        price: document.getElementById('price').value,
        stock: document.getElementById('stock').value,
        category: document.getElementById('category').value
    };

    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(productData)
        });

        const result = await response.json();

        if (response.ok) {
            document.getElementById('productForm').reset();
            fetchProducts(); 
        } else {
            alert(result.message);
        }
    } catch (error) {
        console.error('Błąd wysyłania:', error);
    }
}

// 4. USUWANIE PRODUKTU (DELETE)
async function deleteProduct(id) {
    if (!confirm('Czy na pewno chcesz usunąć ten produkt?')) return;

    try {
        const response = await fetch(API_URL, {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id })
        });

        const result = await response.json();

        if (response.ok) {
            fetchProducts(); 
        } else {
            alert(result.message);
        }
    } catch (error) {
        console.error('Błąd usuwania:', error);
    }
}

// 5. SORTOWANIE (JS SIDE)
function sortProducts(field) {
    if (currentSort.field === field) {
        currentSort.asc = !currentSort.asc;
    } else {
        currentSort.field = field;
        currentSort.asc = true;
    }

    localProducts.sort((a, b) => {
        let valA = a[field];
        let valB = b[field];

        if (field === 'price') {
            valA = parseFloat(valA);
            valB = parseFloat(valB);
        } else {
            valA = valA.toLowerCase();
            valB = valB.toLowerCase();
        }

        if (valA < valB) return currentSort.asc ? -1 : 1;
        if (valA > valB) return currentSort.asc ? 1 : -1;
        return 0;
    });

    renderTable(localProducts);
}

// 6. OBSŁUGA PRZECIĄGANIA (DRAG & DROP)
let draggedRowIndex = null;

function handleDragStart(e) {
    draggedRowIndex = this.dataset.index;
    e.dataTransfer.effectAllowed = 'move';
}

function handleDragOver(e) {
    e.preventDefault(); 
}

function handleDrop(e) {
    e.preventDefault();
    const targetRowIndex = this.dataset.index;

    if (draggedRowIndex === null || draggedRowIndex === targetRowIndex) return;

    const draggedProduct = localProducts.splice(draggedRowIndex, 1)[0];
    localProducts.splice(targetRowIndex, 0, draggedProduct);

    renderTable(localProducts);
    draggedRowIndex = null;
}