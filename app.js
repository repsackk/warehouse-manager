// app.js
const BASE_URL = 'http://localhost/portfolio/warehouse-manager/api';
let currentUser = JSON.parse(localStorage.getItem('erp_user')) || null;
let authAction = 'login';

let localProducts = [];
let currentInvoiceItems = [];
let currentSort = { field: '', asc: true };

document.addEventListener('DOMContentLoaded', () => {
    initApp();
    document.getElementById('loginForm').addEventListener('submit', handleAuth);
    document.getElementById('invoiceForm').addEventListener('submit', handleInvoiceSubmit);
});

function setAuthAction(action) { authAction = action; }

function initApp() {
    if (currentUser) {
        document.getElementById('authScreen').classList.add('hidden');
        document.getElementById('mainDashboard').classList.remove('hidden');
        document.getElementById('navUser').innerText = currentUser.username;
        document.getElementById('navRole').innerText = currentUser.role;

        if (currentUser.role === 'admin') {
            document.getElementById('adminPanel').classList.remove('hidden');
            fetchUnapprovedUsers();
        } else {
            document.getElementById('adminPanel').classList.add('hidden');
        }

        fetchProducts();
    } else {
        document.getElementById('authScreen').classList.remove('hidden');
        document.getElementById('mainDashboard').classList.add('hidden');
    }
}

// LOGOWANIE / REJESTRACJA
async function handleAuth(e) {
    e.preventDefault();
    const username = document.getElementById('authUsername').value;
    const password = document.getElementById('authPassword').value;

    try {
        const response = await fetch(`${BASE_URL}/auth.php?action=${authAction}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, password })
        });
        
        const result = await response.json(); // Czyste parsowanie JSON

        alert(result.message);

        if (response.ok && authAction === 'login') {
            currentUser = result.user;
            localStorage.setItem('erp_user', JSON.stringify(currentUser));
            document.getElementById('loginForm').reset();
            initApp();
        }
    } catch (err) {
        console.error(err);
    }
}

function logout() {
    localStorage.removeItem('erp_user');
    currentUser = null;
    initApp();
}

// POBIERANIE DOSTĘPNOŚCI TOWARÓW
async function fetchProducts() {
    try {
        const response = await fetch(`${BASE_URL}/products.php`);
        localProducts = await response.json();
        renderProductsTable(localProducts);
        populateProductSelect(localProducts);
    } catch (err) {
        console.error(err);
    }
}

function renderProductsTable(products) {
    const tbody = document.getElementById('productsTableBody');
    tbody.innerHTML = '';
    products.forEach(p => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td class="px-4 py-3 font-mono text-xs">${p.sku}</td>
            <td class="px-4 py-3 font-medium">${p.name}</td>
            <td class="px-4 py-3 text-gray-500">${p.category}</td>
            <td class="px-4 py-3 font-bold">${parseFloat(p.price).toFixed(2)} PLN</td>
            <td class="px-4 py-3">
                <span class="px-2 py-0.5 rounded text-xs font-bold ${p.stock > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                    ${p.stock} szt. ${p.stock == 0 ? '(BRAK)' : ''}
                </span>
            </td>
        `;
        tbody.appendChild(row);
    });
}

function populateProductSelect(products) {
    const select = document.getElementById('invProductSelect');
    select.innerHTML = '';
    products.forEach(p => {
        const option = document.createElement('option');
        option.value = p.id;
        option.innerText = `${p.name} (Dostępne: ${p.stock} szt.) - ${p.price} PLN`;
        select.appendChild(option);
    });
}

// SEKCJA ADMINA: AKCEPTACJA PRACOWNIKÓW
async function fetchUnapprovedUsers() {
    try {
        const response = await fetch(`${BASE_URL}/admin.php`);
        const users = await response.json();
        const list = document.getElementById('unapprovedUsersList');
        list.innerHTML = users.length === 0 ? '<li class="text-xs text-gray-400 italic py-2">Brak nowych zgłoszeń.</li>' : '';

        users.forEach(u => {
            const li = document.createElement('li');
            li.className = 'flex justify-between items-center py-2 text-sm';
            li.innerHTML = `
                <span>ID: <b>${u.id}</b> | User: <b>${u.username}</b></span>
                <button onclick="approveUser(${u.id})" class="bg-blue-500 text-white text-xs px-2 py-1 rounded hover:bg-blue-600 cursor-pointer">Zatwierdź</button>
            `;
            list.appendChild(li);
        });
    } catch (err) { console.error(err); }
}

async function approveUser(userId) {
    try {
        const response = await fetch(`${BASE_URL}/admin.php`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ user_id: userId })
        });
        if (response.ok) {
            alert("Użytkownik zatwierdzony!");
            fetchUnapprovedUsers();
        }
    } catch (err) { console.error(err); }
}

// SEKCJA SPRZEDAWCY: KOSZYK I FAKTURY
function addItemToInvoice() {
    const select = document.getElementById('invProductSelect');
    const productId = select.value;
    const qty = parseInt(document.getElementById('invProductQty').value);

    if (!productId || qty < 1) return;

    const product = localProducts.find(p => p.id == productId);
    if (!product) return;

    if (qty > product.stock) {
        alert(`Błąd! Nie masz tylu sztuk na magazynie. Maksymalnie: ${product.stock}`);
        return;
    }

    const existingItem = currentInvoiceItems.find(item => item.product_id == productId);
    if (existingItem) {
        if (existingItem.quantity + qty > product.stock) {
            alert("Łączna ilość przekracza stan magazynowy!");
            return;
        }
        existingItem.quantity += qty;
    } else {
        currentInvoiceItems.push({
            product_id: productId,
            name: product.name,
            quantity: qty
        });
    }

    renderInvoiceItems();
}

function renderInvoiceItems() {
    const list = document.getElementById('invoiceItemsList');
    list.innerHTML = currentInvoiceItems.length === 0 ? '<li class="text-gray-400 italic text-center">Brak dodanych pozycji.</li>' : '';

    currentInvoiceItems.forEach((item, index) => {
        const li = document.createElement('li');
        li.className = 'flex justify-between items-center bg-white p-1 rounded border border-gray-100';
        li.innerHTML = `
            <span>${item.name} x <b>${item.quantity}</b></span>
            <button type="button" onclick="removeItemFromInvoice(${index})" class="text-red-500 font-bold hover:text-red-700 px-1 cursor-pointer">✕</button>
        `;
        list.appendChild(li);
    });
}

function removeItemFromInvoice(index) {
    currentInvoiceItems.splice(index, 1);
    renderInvoiceItems();
}

async function handleInvoiceSubmit(e) {
    e.preventDefault();
    if (currentInvoiceItems.length === 0) {
        alert("Dodaj przynajmniej jeden produkt do faktury!");
        return;
    }

    const invoiceData = {
        client_name: document.getElementById('invClientName').value,
        client_nip: document.getElementById('invClientNip').value,
        seller_id: currentUser.id,
        items: currentInvoiceItems
    };

    try {
        const response = await fetch(`${BASE_URL}/invoices.php`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(invoiceData)
        });
        const result = await response.json();

        alert(result.message);

        if (response.ok) {
            document.getElementById('invoiceForm').reset();
            currentInvoiceItems = [];
            renderInvoiceItems();
            fetchProducts(); // Aktualizuje stany magazynowe w locie!
        }
    } catch (err) { console.error(err); }
}

// SORTOWANIE
function sortProducts(field) {
    if (currentSort.field === field) { currentSort.asc = !currentSort.asc; } 
    else { currentSort.field = field; currentSort.asc = true; }

    localProducts.sort((a, b) => {
        let valA = field === 'price' ? parseFloat(a[field]) : a[field].toLowerCase();
        let valB = field === 'price' ? parseFloat(b[field]) : b[field].toLowerCase();
        return valA < valB ? (currentSort.asc ? -1 : 1) : (valA > valB ? (currentSort.asc ? 1 : -1) : 0);
    });
    renderProductsTable(localProducts);
}